import Foundation
import Power
import ReactiveSwift
import Result

public protocol ImageController {
    var images: MutableProperty<[Image]> { get }
    
    func fetchImages() -> SignalProducer<Void, FetchImagesError>
}

public class DefaultImageController: ImageController {
    private let userController: UserController
    private let networkController: NetworkController
    private let queue = QueueScheduler(targeting: DispatchQueue(label: "net.s3ba.ImgurBrowser.ImageController", qos: .userInitiated))
    
    public init(userController: UserController, networkController: NetworkController) {
        self.userController = userController
        self.networkController = networkController
        
        userController.userLogged
            .signal
            .observe(on: queue)
            .observeValues(fetchImages)
    }
    
    // MARK: ImageController methods
    
    public let images = MutableProperty([Image]())
    
    public func fetchImages() -> SignalProducer<Void, FetchImagesError> {
        return SignalProducer { observer, lifetime in
            let task = RetrieveImagesTask(page: 0)
            
            lifetime += self.networkController.execute(task: task)
                .mapError(FetchImagesError.map)
                .mapToVoid()
                .start(on: self.queue)
                .start(observer)
        }
    }
    
    // MARK: Private methods
    
    private func fetchImages(user: User?) {
        guard user.isNotNil else {
            images.swap([])
            return
        }
        
        let task = RetrieveImagesTask(page: 0)
        
        networkController.execute(task: task)
            .start(on: queue)
            .startWithResult { result in
                switch result {
                case .failure(let error):
                    logError("Could not fetch images. Error: \(error)")
                case .success(let value):
                    self.images.swap(value.data)
                    logTrace("\(value.data.count) images fetched for \((user?.username).textualDescription)")
                }
            }
    }
}

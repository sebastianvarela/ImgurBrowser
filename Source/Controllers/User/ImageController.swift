import Foundation
import Power
import ReactiveSwift
import Result

public protocol ImageController {
    var images: MutableProperty<[Image]> { get }
    
    func delete(image: Image) -> SignalProducer<Void, DeleteError>
    func upload(attachment: AttachmentViewModel) -> SignalProducer<Void, UploadError>
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
    
    public func delete(image: Image) -> SignalProducer<Void, DeleteError> {
        return SignalProducer { observer, lifetime in
            let task = DeleteImageTask(image: image)
            
            lifetime += self.networkController.execute(task: task)
                .mapError(DeleteError.map)
                .mapToVoid()
                .onValue { _ in
                    if let index = self.images.value.lastIndex(where: { $0.id == image.id }) {
                        self.images.value.remove(at: index)
                    }
                }
                .start(on: self.queue)
                .start(observer)
        }
    }
    
    public func upload(attachment: AttachmentViewModel) -> SignalProducer<Void, UploadError> {
        return SignalProducer { observer, lifetime in
            let task = UploadImageTask(attachment: attachment)
            
            lifetime += self.networkController.execute(task: task)
                .mapError(UploadError.map)
                .mapToVoid()
                .start(on: self.queue)
                .start(observer)
        }
    }
    
    public func fetchImages() -> SignalProducer<Void, FetchImagesError> {
        return SignalProducer { observer, lifetime in
            let task = RetrieveImagesTask(page: 0)
            
            lifetime += self.networkController.execute(task: task)
                .mapError(FetchImagesError.map)
                .onValue { self.images.swap($0.data) }
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

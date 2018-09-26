import Foundation
import ReactiveSwift
import Result

public class DefaultHomeInteractor: HomeInteractor {
    private let userController: UserController
    private let imageController: ImageController
    
    public init(userController: UserController, imageController: ImageController) {
        self.userController = userController
        self.imageController = imageController
        
        userLogged <~ userController.userLogged
        images <~ imageController.images
	}

    // MARK: - HomeInteractor methods

    public let userLogged = MutableProperty<User?>(nil)
    public let images = MutableProperty([Image]())

    public func logout() {
        userController.logout()
    }
    
    public func refreshImages() -> SignalProducer<Void, RefreshingImagesError> {
        return imageController.fetchImages()
            .mapError(RefreshingImagesError.map)
    }
    
    // MARK: - Private methods
}

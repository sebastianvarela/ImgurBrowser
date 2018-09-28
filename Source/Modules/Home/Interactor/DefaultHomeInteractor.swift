import Foundation
import Power
import ReactiveSwift
import Result

public class DefaultHomeInteractor: HomeInteractor {
    private let userController: UserController
    private let imageController: ImageController
    private let permissionWrapper: PermissionWrapper
    
    public init(userController: UserController, imageController: ImageController, permissionWrapper: PermissionWrapper) {
        self.userController = userController
        self.imageController = imageController
        self.permissionWrapper = permissionWrapper
        
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
    
    public func checkPermissionForMedia() -> SignalProducer<Bool, NoError> {
        return SignalProducer { observer, _ in
            if self.permissionWrapper.authorizationStatus(forPermission: .photoLibraryAccess) == .notDetermined {
                self.permissionWrapper.requestAccess(forPermission: .photoLibraryAccess)
                    .observe(on: UIScheduler())
                    .startWithValues { authorisationStatus in
                        if authorisationStatus.isAuthorized() {
                            observer.send(value: true)
                        } else {
                            observer.send(value: false)
                        }
                        observer.sendCompleted()
                    }
            } else if self.permissionWrapper.authorizationStatus(forPermission: .photoLibraryAccess).isAuthorized() {
                observer.send(value: true)
                observer.sendCompleted()
            } else {
                observer.send(value: false)
                observer.sendCompleted()
            }
        }
    }
    
    // MARK: - Private methods
}

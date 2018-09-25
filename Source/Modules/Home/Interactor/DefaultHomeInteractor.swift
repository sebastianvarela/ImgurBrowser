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
	}

    // MARK: - HomeInteractor methods

    public let userLogged = MutableProperty<User?>(nil)
    
    public func logout() {
        userController.logout()
    }
    
    // MARK: - Private methods
}

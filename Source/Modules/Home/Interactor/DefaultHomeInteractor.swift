import Foundation
import ReactiveSwift
import Result

public class DefaultHomeInteractor: HomeInteractor {
    private let userController: UserController
    
    public init(userController: UserController) {
        self.userController = userController
        
        userLogged <~ userController.userLogged
	}

    // MARK: - HomeInteractor methods

    public let userLogged = MutableProperty<User?>(nil)
    
    public func logout() {
        userController.logout()
    }
    
    // MARK: - Private methods
}

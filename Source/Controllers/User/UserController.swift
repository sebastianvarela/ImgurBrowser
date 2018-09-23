import Foundation
import ReactiveSwift
import Result

public protocol UserController {
    var userLogged: MutableProperty<User?> { get }
}

public class DefaultUserController: UserController {
    
    public init() {
        
    }
    
    // MARK: UserController methods
    
    public var userLogged = MutableProperty<User?>(nil)
    
    // MARK: Private methods
    
}

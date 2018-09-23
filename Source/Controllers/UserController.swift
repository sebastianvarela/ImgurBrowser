import Foundation
import ReactiveSwift
import Result

public protocol UserController {
    var userLogged: MutableProperty<Bool> { get }
}

public class DefaultUserController: UserController {
    
    public init() {
        
    }
    
    // MARK: UserController methods
    
    public var userLogged = MutableProperty(false)
    
    // MARK: Private methods
    
}

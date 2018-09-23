import Foundation
import ReactiveSwift
import Result

public protocol HomePresenter: Presenter {
    var userLogged: MutableProperty<User?> { get }
    
    func addPhoto()
    func enableEditMode()
    func logout()
    func login()
}

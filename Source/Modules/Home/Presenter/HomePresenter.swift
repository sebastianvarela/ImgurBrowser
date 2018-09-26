import Foundation
import ReactiveSwift
import Result

public protocol HomePresenter: Presenter {
    var userLogged: MutableProperty<User?> { get }
    var refreshAction: Action<Void, Void, NoError> { get }
    var images: MutableProperty<[Image]> { get }
    
    func addImage()
    func enableEditMode()
    func logout()
    func login()
    func show(image: Image)
}

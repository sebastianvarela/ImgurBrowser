import Foundation
import ReactiveSwift
import Result

public protocol HomePresenter: Presenter {
    var userLogged: MutableProperty<User?> { get }
    var refreshAction: Action<Void, Void, NoError> { get }
    var images: MutableProperty<[Image]> { get }
    
    func addImage()
    func enableEditMode()
    func disableEditMode()
    func logout()
    func login()
    func upload(attachment: AttachmentViewModel)
    func delete(image: Image)
    func show(image: Image)
}

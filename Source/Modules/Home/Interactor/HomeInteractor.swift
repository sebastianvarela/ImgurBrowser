import Foundation
import ReactiveSwift
import Result

public protocol HomeInteractor: Interactor {
    var userLogged: MutableProperty<User?> { get }
    var images: MutableProperty<[Image]> { get }
    
    func logout()
    func refreshImages() -> SignalProducer<Void, RefreshingImagesError>
    func checkPermissionForMedia() -> SignalProducer<Bool, NoError>
}

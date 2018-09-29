import Foundation
import ReactiveSwift
import Result

public protocol HomeInteractor: Interactor {
    var userLogged: MutableProperty<User?> { get }
    var images: MutableProperty<[Image]> { get }
    
    func logout()
    func upload(attachment: AttachmentViewModel) -> SignalProducer<Void, UploadingAttachmentError>
    func delete(image: Image) -> SignalProducer<Void, DeletingImageError>
    func refreshImages() -> SignalProducer<Void, RefreshingImagesError>
    func checkPermissionForMedia() -> SignalProducer<Bool, NoError>
}

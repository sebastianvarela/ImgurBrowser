import Foundation
import Power
import ReactiveSwift
import Result

public class DefaultHomePresenter: HomePresenter {
    private weak var view: HomeView?
    private let interactor: HomeInteractor
    private let wireframe: RootWireframe

    public init(view: HomeView, interactor: HomeInteractor, wireframe: RootWireframe) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
        
        userLogged <~ interactor.userLogged
        images <~ interactor.images
    }

    // MARK: - HomePresenter methods

    public let userLogged = MutableProperty<User?>(nil)
    public let images = MutableProperty([Image]())

    public var refreshAction: Action<Void, Void, NoError> {
        return Action<Void, Void, NoError> { _ in
            logTrace("Updating images")
            
            return SignalProducer { observer, lifetime in
                lifetime += self.interactor.refreshImages()
                    .observe(on: UIScheduler())
                    .onFailed { self.view?.presentAlert(title: $0.title, subTitle: $0.subTitle) }
                    .startWithResult { _ in
                        observer.sendCompleted()
                    }
            }
        }
    }
    
    public func addImage() {
        interactor.checkPermissionForMedia()
            .start(on: UIScheduler())
            .startWithValues { canAccess in
                if canAccess {
                    self.view?.showImagePicker()
                } else {
                    self.view?.presentAlert(title: NSLocalizedString("General.Alert.PermissionTitle"),
                                            subTitle: NSLocalizedString("General.Alert.PermissionBody")) {
                                                self.view?.showSystemSettings(completion: nil)
                    }
                }
            }
    }
    
    public func enableEditMode() {
        view?.enableEditMode()
    }
    
    public func disableEditMode() {
        view?.disableEditMode()
    }
    
    public func logout() {
        interactor.logout()
    }
    
    public func login() {
        wireframe.showLogin()
    }
    
    public func upload(attachment: AttachmentViewModel) {
        view?.showGlobalSpinnerView()
        interactor.upload(attachment: attachment)
            .onProcessError(showOn: view, wireframe: wireframe)
            .flatMap(.concat) { _ in self.interactor.refreshImages() }
            .onProcessError(showOn: view, wireframe: wireframe)
            .start(on: UIScheduler())
            .startWithCompleted {
                self.view?.hideGlobalSpinnerView()
                self.view?.focusOnFirstImage()
            }
    }
    
    public func delete(image: Image) {
        view?.showGlobalSpinnerView()
        interactor.delete(image: image)
            .start(on: UIScheduler())
            .onProcessError(showOn: view, wireframe: wireframe)
            .startWithCompleted {
                self.view?.hideGlobalSpinnerView()
            }
    }

    public func show(image: Image) {
        guard let index = images.value.firstIndex(where: { $0 == image }) else {
            return
        }
        
        wireframe.preview(images: images.value, focusOn: index)
    }
    
    // MARK: - Private methods
}

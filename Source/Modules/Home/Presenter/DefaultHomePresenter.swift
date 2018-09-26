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
            
            return self.interactor.refreshImages()
                .onProcessError(showOn: self.view, wireframe: self.wireframe)
                .mapToVoid()
        }
    }
    
    public func addImage() {
        
    }
    
    public func enableEditMode() {
        
    }
    
    public func logout() {
        interactor.logout()
    }
    
    public func login() {
        wireframe.showLogin()
    }
    
    public func show(image: Image) {
        
    }
    
    // MARK: - Private methods
}

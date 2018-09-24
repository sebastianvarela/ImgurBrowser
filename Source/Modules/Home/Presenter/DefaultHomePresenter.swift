import Foundation
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
    }
    
    public func viewDidLoad() {
        if interactor.userLogged.value.isNil {
            wireframe.showLogin()
        }
    }

    // MARK: - HomePresenter methods

    public var userLogged = MutableProperty<User?>(nil)
    
    public func addPhoto() {
        
    }
    
    public func enableEditMode() {
        
    }
    
    public func logout() {
        interactor.logout()
    }
    
    public func login() {
        wireframe.showLogin()
    }
    
    // MARK: - Private methods
}

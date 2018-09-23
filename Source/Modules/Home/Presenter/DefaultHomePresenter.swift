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
    }
    
    public func viewDidLoad() {
        if interactor.userLogged.value.isFalse {
            wireframe.showLogin()
        }
    }

    // MARK: - HomePresenter methods

    // MARK: - Private methods
}

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

    }

    // MARK: - HomePresenter methods

    // MARK: - Private methods
}

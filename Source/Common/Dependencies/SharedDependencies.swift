import Foundation
import Power
import ReactiveSwift

public class SharedDependencies {
    public init() {

    }
    
    // MARK: - Controllers

    public lazy var versionsController: VersionsController = {
        return DefaultVersionsController(environmentController: environmentController)
    }()

    public lazy var userDefaultsWrapper: UserDefaultsWrapper = {
        return DefaultUserDefaultsWrapper()
    }()

    public lazy var keychainWrapper: KeychainWrapper = {
        return DefaultKeychainWrapper()
    }()
    
    public lazy var environmentController: EnvironmentController = {
        return DefaultEnvironmentController()
    }()
   
    // MARK: - Interactors

    public lazy var homeInteractor: HomeInteractor = {
        return DefaultHomeInteractor()
    }()
    
    // MARK: - Default Presenters
    
    public func defaultHomePresenter(view: HomeView, interactor: HomeInteractor, wireframe: RootWireframe) -> DefaultHomePresenter {
        return DefaultHomePresenter(view: view, interactor: interactor, wireframe: wireframe)
    }
    
    // MARK: - Default Presenters

}

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
    
    public lazy var userController: UserController = {
        return DefaultUserController(networkController: networkController, keychainWrapper: keychainWrapper)
    }()
    
    public lazy var imageController: ImageController = {
        return DefaultImageController(userController: userController, networkController: networkController)
    }()
    
    public lazy var networkController: NetworkController = {
        return DefaultNetworkController(environmentController: environmentController)
    }()
   
    // MARK: - Interactors

    public lazy var homeInteractor: HomeInteractor = {
        return DefaultHomeInteractor(userController: userController, imageController: imageController)
    }()
    
    public lazy var loginInteractor: LoginInteractor = {
        return DefaultLoginInteractor(userController: userController, environmentController: environmentController)
    }()
    
    // MARK: - Default Presenters
    
    public func defaultHomePresenter(view: HomeView, interactor: HomeInteractor, wireframe: RootWireframe) -> DefaultHomePresenter {
        return DefaultHomePresenter(view: view, interactor: interactor, wireframe: wireframe)
    }
    
    public func defaultLoginPresenter(view: LoginView, interactor: LoginInteractor, wireframe: RootWireframe) -> DefaultLoginPresenter {
        return DefaultLoginPresenter(view: view, interactor: interactor, wireframe: wireframe)
    }
    
    // MARK: - Default Presenters

}

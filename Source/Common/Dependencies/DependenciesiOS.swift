import Foundation
import Power
import UIKit

public class DependenciesiOS: SharedDependencies {
    public let window: UIWindow
    public let toastManager: ToastManager
    
    public init(window: UIWindow) {
        self.window = window
        toastManager = ToastManager(applicationRootWindow: window)
        
        super.init()
        
        super.networkController
            .connecting
            .signal
            .observeValuesOnUIScheduler(rootWireframe.updateGlobalNetworkActivity)
    }
    
    public lazy var factory: Factory = {
        return Factory()
    }()
    
    // MARK: - Wireframes
    
    public lazy var rootWireframe: RootWireframe = {
        RootWireframeiOS(window: self.window, dependencies: self)
    }()
    
    // MARK: - ViewControllers

    public func homeViewController() -> HomeViewController {
        let vc = factory.createVC() as HomeViewController
        vc.presenter = super.defaultHomePresenter(view: vc,
                                                  interactor: super.homeInteractor,
                                                  wireframe: rootWireframe)
        return vc
    }
    
    public func loginViewController() -> LoginViewController {
        let vc = factory.createVC() as LoginViewController
        vc.presenter = super.defaultLoginPresenter(view: vc,
                                                   interactor: super.loginInteractor,
                                                   wireframe: rootWireframe)
        return vc
    }
}

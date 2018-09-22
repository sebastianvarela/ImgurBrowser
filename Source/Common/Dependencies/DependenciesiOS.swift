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
}

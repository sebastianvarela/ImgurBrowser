import Foundation
import ReactiveSwift
import Result
import UIKit

public class RootWireframeiOS: RootWireframe {
    private let window: UIWindow
    private let dependencies: DependenciesiOS
    private var alertTransition: AlertTransitionManager?

    private lazy var navController: ImgurBrowserNavigationController = {
        return ImgurBrowserNavigationController()
    }()
    
    public init(window: UIWindow, dependencies: DependenciesiOS) {
        self.window = window
        self.dependencies = dependencies
    }
    
    public func updateGlobalNetworkActivity(visible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = visible
    }
    
    public func presentMainView() {
        let homeVC = dependencies.homeViewController()
        navController.viewControllers = [homeVC]
        window.rootViewController = navController
    }
    
    public func showLogin() {
        let loginVC = dependencies.loginViewController()
        let loginNav = ImgurBrowserNavigationController()
        loginNav.viewControllers = [loginVC]
        navController.present(loginNav, animated: true)
    }
    
    public func close() {
        exit(0)
    }
    
    // MARK: - Private methods
    
    private func setRoot(viewcontroller: UIViewController, using: WireframeLoadType, completion: (() -> Void)? = nil) {
        guard let topVC = navController.viewControllers.last else {
            completion?()
            return
        }
        
        switch using {
        case .pop:
            navController.viewControllers = [viewcontroller, topVC]
            navController.popToRootViewController(animated: true, completion: completion)

        case .push:
            navController.pushViewController(viewController: viewcontroller, animated: true) {
                self.navController.viewControllers = [viewcontroller]
                completion?()
            }
        }
    }
}

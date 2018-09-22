import UIKit

public class ImgurBrowserNavigationController: UINavigationController, UINavigationControllerDelegate {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let backImage = UIImage(named: "NavigationBack")
        navigationBar.backIndicatorImage = backImage
        navigationBar.backIndicatorTransitionMaskImage = backImage
        
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: UINavigationControllerDelegate
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        guard let ibncv = viewController as? ImgurBrowserNavigationControllerView else {
            return
        }
        
        navigationBar.tintColor = ibncv.navigationForegroundColor.withAlphaComponent(0.99)
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ibncv.navigationForegroundColor.withAlphaComponent(0.99),
                                             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let ibncv = viewController as? ImgurBrowserNavigationControllerView else {
            return
        }
        
        navigationBar.tintColor = ibncv.navigationForegroundColor
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ibncv.navigationForegroundColor,
                                             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
    }
}

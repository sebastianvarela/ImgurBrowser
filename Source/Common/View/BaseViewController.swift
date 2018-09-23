import Foundation
import Power
import ReactiveCocoa
import ReactiveSwift
import Result
import SVProgressHUD
import UIKit

public class BaseViewController<P: Presenter>: UIViewController, View, ImgurBrowserNavigationControllerView {
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        logTrace("🙌 init \(self)")
    }
    
    private var _presenter: P?
    public var presenter: P {
        set {
            _presenter = newValue
        }
        get {
            guard let currentPresenter = _presenter else {
                fatalError("\(self) does not have an attached presenter")
            }
            return currentPresenter
        }
    }
    
    public var dependencies: DependenciesiOS {
        return AppDelegate.shared.dependencies
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupGUI()
        
        if presenter.shouldHideBackTitle {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        if showCloseOnNavigationBar {
            navigationItem.hidesBackButton = true
            let closeImage = UIImage(named: "NavigationClose")
            let closeButtonItem = UIBarButtonItem(image: closeImage, style: .plain, target: nil, action: nil)
            closeButtonItem.reactive.pressed = CocoaAction(navigationBarCloseAction)
            navigationItem.rightBarButtonItem = closeButtonItem
        }
        
        presenter.viewDidLoad()
        setupProgressIndicator()
    }
    
    public func setupGUI() {

    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        presenter.didReceiveMemoryWarning()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: false)
        navigationController?.setToolbarHidden(hideToolbar, animated: false)
        
        presenter.viewWillAppear(animated: animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear(animated: animated)
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(hideNavigationBar, animated: false)
        navigationController?.setToolbarHidden(hideToolbar, animated: false)

        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }

        super.viewWillDisappear(animated)
        presenter.viewWillDisappear(animated: animated)
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        presenter.viewDidDisappear(animated: animated)
    }
    
    deinit {
        logTrace("👋 deinit \(self)")
    }

    // MARK: - View
    public override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        if isModal {
            super.dismiss(animated: flag, completion: completion)
        } else {
            _ = navigationController?.popViewController(animated: flag, completion: completion)
        }
    }
    
    public func dismiss(animated flag: Bool) {
        dismiss(animated: flag, completion: nil)
    }
    
    public func showSystemSettings(completion: (() -> Void)? = nil) {
        if let appSettings = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(appSettings, options: [:]) { _ in
                completion?()
            }
        }
    }

    // MARK: - AlertPresentable
    private var alertTransition: AlertTransitionManager?

    public func presentAlert(title: String, subTitle: String, stringLocation: String, okAction: View.AlertAction?) {
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
        
        let alert: AlertViewController = UIViewController.initFromStoryboard()
        _ = alert.view.isHidden // Hack to manually load the viewController

        alert.setupAlert(title: title, subTitle: subTitle, okAction: okAction)

        alertTransition = AlertTransitionManager(source: self, destination: alert)
        alert.transitioningDelegate = alertTransition

        logTrace("Presenting alert \"\(title)\" from \(stringLocation)")
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - SpinnerViewAvailable
    
    public func showGlobalSpinnerView() {
        SVProgressHUD.show()
    }
    
    public func hideGlobalSpinnerView() {
        SVProgressHUD.dismiss()
    }
    
    private func setupProgressIndicator() {
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setBackgroundLayerColor(UIColor(white: 0, alpha: 0.6))
        SVProgressHUD.setDefaultStyle(.custom)
    }

    // MARK: - ImgurBrowserNavigationControllerView
    
    public var navigationForegroundColor: UIColor {
        return .imgurBrowserGreenText
    }
    
    public var hideNavigationBar: Bool {
        return false
    }
    
    public var showCloseOnNavigationBar: Bool {
        return false
    }
    
    public var hideToolbar: Bool {
        return true
    }
    
    // MARK: - Navigation Actions:
    
    public lazy var navigationBarCloseAction: Action<Void, Void, NoError> = {
        let enabledIf = Property(value: true)
        let action = Action<Void, Void, NoError>(enabledIf: enabledIf) { _ in
            return SignalProducer { observer, _ in
                observer.sendCompleted()
            }
        }
        return action
    }()
}

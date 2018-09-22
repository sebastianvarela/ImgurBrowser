import Foundation
import Power
import ReactiveSwift
import Result
import UIKit

public class ToastManager {
    public var toastWindow: ToastWindow?
    
    fileprivate var toastAlertsViewController: ToastAlertViewController?
    fileprivate var toastAlertsModels = [ToastAlert]()
    
    fileprivate var removeAlertSignal: Signal<ToastRemoveType, NoError>
    fileprivate var removeAlertObserver: Signal<ToastRemoveType, NoError>.Observer
    fileprivate var removeAlertDisposable: Disposable?
    
    fileprivate let applicationRootWindow: UIWindow
    
    fileprivate var dismissing = false {
        didSet {
            if dismissing == false && !dismissingCache.isEmpty {
                dismissingCache.forEach(addToastAlert)
                dismissingCache.removeAll()
            }
        }
    }
    fileprivate var dismissingCache = [ToastAlert]()
    
    public init(applicationRootWindow: UIWindow) {
        self.applicationRootWindow = applicationRootWindow
        (removeAlertSignal, removeAlertObserver) = Signal.pipe()
    }
    
    fileprivate func subscribeToRemoveAlertsSignal() {
        removeAlertDisposable = removeAlertSignal.observeValues { [unowned self] removeType in
            self.toastAlertsModels.removeFirst()
            
            if self.toastAlertsModels.isEmpty {
                self.removeToastAlertWindowAndViewController()
            } else {
                if let firstModel = self.toastAlertsModels.first {
                    switch removeType {
                    case .fromTimer:
                        self.toastAlertsViewController?.removeCurrentToastViewFromTimerAndPresentNext(firstModel)
                    case .fromPanGesture:
                        self.toastAlertsViewController?.removeCurrentToastViewFromPanGestureAndPresentNext(firstModel)
                    case .fromTapGesture:
                        self.toastAlertsViewController?.removeCurrentToastViewFromPanGestureAndPresentNext(firstModel)
                    }
                }
            }
        }
    }
    
    public func addToastAlert(_ newToastAlert: ToastAlert) {
        if dismissing {
            dismissingCache.append(newToastAlert)
            return
        }
        
        logInfo("Adding toast alert of level \"\(newToastAlert.level)\": \(newToastAlert.message)")
        
        toastAlertsModels.append(newToastAlert)
        
        if toastAlertsModels.count == 1 {
            presentWindowAndViewController(newToastAlert)
        }
    }
    
    fileprivate func presentWindowAndViewController(_ toastAlertModel: ToastAlert) {
        let toastWindow = ToastWindow()
        toastWindow.backgroundColor = .clear
        toastWindow.clipsToBounds = false
        toastWindow.layer.cornerRadius = 3.0
        subscribeToRemoveAlertsSignal()
        
        let toastAlertsViewController = ToastAlertViewController(toastWindow: toastWindow, firstToastAlertModel: toastAlertModel, removeAlertObserver: removeAlertObserver)
        toastWindow.presentAlertViewController(toastAlertsViewController, windowLevel: UIWindow.Level.alert + 1, animated: false)
        
        self.toastWindow = toastWindow
        self.toastAlertsViewController = toastAlertsViewController
        applicationRootWindow.makeKeyAndVisible()
    }
    
    fileprivate func removeToastAlertWindowAndViewController() {
        dismissing = true
        removeAlertDisposable?.dispose()
        toastAlertsViewController?.dismiss(animated: false) {
            self.toastWindow?.rootViewController = nil
            self.toastAlertsViewController = nil
            self.toastWindow?.removeFromSuperview()
            self.toastWindow?.isHidden = true
            self.toastWindow = nil
            self.applicationRootWindow.makeKeyAndVisible()
            self.dismissing = false
        }
    }
}

public class ToastWindow: UIWindow {
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard
            let alertVC = rootViewController?.presentedViewController as? ToastAlertViewController,
            let view = alertVC.currentToastView,
            view.isNotHidden && view.alpha > 0 && view.isUserInteractionEnabled && view.point(inside: convert(point, to: view), with: event) else {
                return false
        }
        return true
    }
    
    public func presentAlertViewController(_ viewController: UIViewController, windowLevel: UIWindow.Level, animated: Bool, completion: (() -> Void)? = nil) {
        self.windowLevel = windowLevel
        let rootViewController = UIViewController()
        self.rootViewController = rootViewController
        makeKeyAndVisible()
        rootViewController.present(viewController, animated: animated, completion: completion)
    }
    
    deinit {
        logTrace("👋 Alert Window")
    }
}

public func += (left: ToastManager, right: ToastAlert) {
    left.addToastAlert(right)
}

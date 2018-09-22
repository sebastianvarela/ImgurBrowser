import Cartography
import Foundation
import Power
import ReactiveSwift
import Result
import UIKit

public class ToastAlertViewController: UIViewController {
    public let animationDuration: TimeInterval = 0.3
    
    private var toastWindow: UIWindow
    
    private var currentToastAlertModel: ToastAlert
    private (set) public var currentToastView: UIView?
    private let removeAlertObserver: Signal<ToastRemoveType, NoError>.Observer
    
    private var timer: PausableTimer?
    private var panGestureRecognizer: UIPanGestureRecognizer
    private var tapGestureRecognizer: UITapGestureRecognizer
    
    public init(toastWindow: ToastWindow, firstToastAlertModel: ToastAlert, removeAlertObserver: Signal<ToastRemoveType, NoError>.Observer) {
        self.toastWindow = toastWindow
        self.removeAlertObserver = removeAlertObserver
        currentToastAlertModel = firstToastAlertModel

        panGestureRecognizer = UIPanGestureRecognizer()
        tapGestureRecognizer = UITapGestureRecognizer()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var topConstraint: NSLayoutConstraint?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        panGestureRecognizer.addTarget(self, action: #selector(ToastAlertViewController.handlePanGesture(_:)))
        tapGestureRecognizer.addTarget(self, action: #selector(ToastAlertViewController.handleTapGesture(_:)))

        currentToastView = currentToastAlertModel.buildToastAlertView()
        if let currentToastView = currentToastView {
            self.placeToastViewInView(currentToastView)
        }
        currentToastView?.addGestureRecognizer(tapGestureRecognizer)
        currentToastView?.addGestureRecognizer(panGestureRecognizer)

        topConstraint?.constant = -200
        
        self.configureTimer()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.topConstraint?.constant = 60
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 1,
                       options: .allowUserInteraction,
                       animations: {
                            self.view.layoutIfNeeded()
                       },
                       completion: nil)
    }
    
    fileprivate func configureTimer() {
        if !currentToastAlertModel.persistent {
            weak var weakSelf = self
            timer = PausableTimer(timerDuration: ToastAlert.toastDuration) {
                    weakSelf?.removeAlertObserver.send(value: .fromTimer)
            }.start()
        }
    }
    
    fileprivate func placeToastViewInView(_ toastView: UIView) {
        view.addSubview(toastView)
        
        let maxWidth: CGFloat = 500
        
        constrain(toastView, self.view) { toastView, toastContainerView in
            topConstraint = toastView.top == toastContainerView.top + 60
            toastView.width == maxWidth ~ LayoutPriority(rawValue: 750)
            toastView.leading >= toastContainerView.leading + 20
            toastView.trailing <= toastContainerView.trailing - 20
            toastView.centerX == toastContainerView.centerX
        }
    }
    
    @objc
    fileprivate func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        self.removeAlertObserver.send(value: .fromTapGesture)
    }
    
    @objc
    fileprivate func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        guard let gestureView = gestureRecognizer.view else {
            return
        }
        
        switch gestureRecognizer.state {
        case .began:
            timer?.pause()
            let translation = gestureRecognizer.translation(in: self.view)
            gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y)
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)

        case .changed:
            let translation = gestureRecognizer.translation(in: self.view)
            gestureView.center = CGPoint(x: gestureView.center.x + translation.x, y: gestureView.center.y)
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.view)

        case .ended:
            let distanceFromCenter = gestureView.center.x - (toastWindow.bounds.width / 2.0)
            let distanceSign = distanceFromCenter / abs(distanceFromCenter)
            if abs(distanceFromCenter) > 50 {
                let animationDistance = self.view.bounds.width * distanceSign
                let initialSpringVelocity: CGFloat = abs(gestureRecognizer.velocity(in: self.view).x / animationDistance)
                UIView.animate(withDuration: animationDuration,
                               delay: 0.0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: initialSpringVelocity,
                               options: .allowUserInteraction,
                               animations: {
                                    gestureRecognizer.view?.transform = CGAffineTransform(translationX: animationDistance, y: 0.0)
                               },
                               completion: { [unowned self] _ in
                                    self.toastXCoordinate = self.currentToastView?.frame.origin.x ?? 0.0
                                    self.removeAlertObserver.send(value: .fromPanGesture)
                })
            } else {
                let animationDistance = abs(distanceFromCenter) * -distanceSign
                UIView.animate(withDuration: 0.2,
                               delay: 0.0,
                               options: .allowUserInteraction,
                               animations: {
                                    gestureRecognizer.view?.transform = CGAffineTransform(translationX: animationDistance, y: 0.0)
                               },
                               completion: { [unowned self] _ in
                                    self.timer?.resume()
                })
            }
            
        case .cancelled, .failed:
            self.timer?.resume()
            
        default:
            break
        }
    }
    
    private var toastXCoordinate: CGFloat = 0.0
    
    public override func dismiss(animated flag: Bool, completion: (() -> Void)?) {
        if let currentToastView = currentToastView {
            currentToastView.removeGestureRecognizer(panGestureRecognizer)
            UIView.animate(withDuration: animationDuration,
                           delay: 0.0,
                           options: .allowUserInteraction,
                           animations: {
                                currentToastView.transform = CGAffineTransform(translationX: currentToastView.frame.origin.x, y: 3.0 * -currentToastView.bounds.height)
                           },
                           completion: { _ in
                                super.dismiss(animated: flag, completion: completion)
            })
        } else {
            super.dismiss(animated: flag, completion: completion)
        }
    }
    
    // MARK: - Toast views remove and present next methods
    
    public func removeCurrentToastViewFromTimerAndPresentNext(_ nextToastAlertModel: ToastAlert) {
        guard let currentToastView = currentToastView else {
            logError("There's no current toast view to remove.")
            return
        }
        
        timer?.stop()
        
        let nextToastView = nextToastAlertModel.buildToastAlertView()
        placeToastViewInView(nextToastView)
        nextToastView.alpha = 0.0
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
                            currentToastView.transform = CGAffineTransform(translationX: 0, y: 3.0 * -currentToastView.bounds.height)
                       },
                       completion: { [unowned self] _ in
                            UIView.animate(withDuration: self.animationDuration,
                                           animations: {
                                                nextToastView.alpha = 1.0
                                           },
                                           completion: { [unowned self] _ in
                                                currentToastView.removeFromSuperview()
                                                self.currentToastAlertModel = nextToastAlertModel
                                                self.currentToastView = nextToastView
                                                self.currentToastView?.addGestureRecognizer(self.panGestureRecognizer)
                                                self.configureTimer()
                            })
        })
    }
    
    public func removeCurrentToastViewFromPanGestureAndPresentNext(_ nextToastAlertModel: ToastAlert) {
        guard let currentToastView = currentToastView else {
            logError("There's no current toast view to remove.")
            return
        }
        
        timer?.stop()
        
        currentToastView.alpha = 0.0
        
        let nextToastView = nextToastAlertModel.buildToastAlertView()
        currentToastView.removeFromSuperview()
        placeToastViewInView(nextToastView)
        currentToastAlertModel = nextToastAlertModel
        self.currentToastView = nextToastView
        
        currentToastView.alpha = 0.0
        currentToastView.removeGestureRecognizer(panGestureRecognizer)
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: .allowUserInteraction,
                       animations: {
            currentToastView.alpha = 1.0
        }, completion: { _ in
            currentToastView.addGestureRecognizer(self.panGestureRecognizer)
            self.configureTimer()
        })
    }
    
    deinit {
        logTrace("👋 ToastAlertsViewController")
        timer?.stop()
    }
}

import UIKit

public class AlertTransitionManager: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    fileprivate var presenting = false
    fileprivate var interactive = false
    private weak var sourceViewController: UIViewController?
    private weak var destinationViewController: UIViewController?

    public init(source: UIViewController, destination: UIViewController) {
        super.init()
        
        sourceViewController = source
        sourceViewController?.transitioningDelegate = self

        destinationViewController = destination
        destinationViewController?.modalPresentationStyle = .custom
        
        completionCurve = .easeIn
    }

    // # MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if presenting {
            animatePresentation(with: transitionContext)
        } else {
            animateDismissal(with: transitionContext)
        }
    }
    
    public func animatePresentation(with transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            return
        }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(presentedControllerView)
        
        let transform = CGAffineTransform(translationX: 0, y: presentedControllerView.bounds.height)
        let animation = { presentedControllerView.transform = transform }
        commitAnimation(context: transitionContext, animation: animation)
    }
    
    public func animateDismissal(with transitionContext: UIViewControllerContextTransitioning) {
        guard let presentedControllerView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            return
        }
        
        let transform = presentedControllerView.transform.translatedBy(x: 0, y: -presentedControllerView.bounds.height * 2)
        let animation = { presentedControllerView.transform = transform }
        commitAnimation(context: transitionContext, animation: animation)
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    // # MARK: UIViewControllerTransitioningDelegate protocol methods
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return AlertBlackViewPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = true
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return self.interactive ? self : nil
    }
    
    // # MARK: Private methods
    
    fileprivate func commitAnimation(context transitionContext: UIViewControllerContextTransitioning, animation: @escaping () -> Void) {
        // El delay es necesario debido a un bug que existe en cancelar la transición cuando se cancela el gesto.
        // Es necesario esperar a que se ejecute el cancel() para saber cual es el estado real de transitionContext.transitionWasCancelled.
        // http://www.openradar.me/16607330
        UIView.animate(withDuration: transitionDuration(using: transitionContext),
                       delay: 0.0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.8,
                       options: .allowUserInteraction,
                       animations: animation) { _ in
                        delay(0.1) {
                            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                        }
        }
    }
}

public class AlertBlackViewPresentationController: UIPresentationController {
    public lazy var dimmingView: UIView = {
        let view = UIView(frame: self.adjustDimmingRect)
        view.autoresizingMask = []
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        
        return view
    }()
    
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
    }
    
    public func dismissPresentedViewController() {
        presentingViewController.dismiss(animated: false, completion: nil)
    }
    
    public override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            return
        }
        
        dimmingView.alpha = 0.0
        containerView?.addSubview(dimmingView)
        
        transitionCoordinator
            .animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.7
            }, completion: nil)
    }
    
    public override var shouldPresentInFullscreen: Bool {
        return false
    }
    
    public override var frameOfPresentedViewInContainerView: CGRect {
        return adjustedRect
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    public override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedViewController.view.frame = adjustedRect
        dimmingView.frame = adjustDimmingRect
    }
    
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        if !completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    public override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        
        guard let transitionCoordinator = presentingViewController.transitionCoordinator else {
            return
        }
        
        transitionCoordinator
            .animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0.0
            }, completion: nil)
    }
    
    public override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        
        if completed {
            dimmingView.removeFromSuperview()
        }
    }
    
    // # MARK: Private methods
    
    fileprivate var adjustedRect: CGRect {
        guard let alertVC = presentedViewController as? AlertView else {
            return presentedViewController.view.bounds
        }
        
        let presentingSize = presentingViewController.view.bounds.size
        let width = alertVC.containerSize.width - 20
        
        return CGRect(x: (presentingSize.width - width) / 2,
                      y: presentingSize.height / 2 - alertVC.containerSize.height / 2,
                      width: width,
                      height: alertVC.containerSize.height)
    }
    
    fileprivate var adjustDimmingRect: CGRect {
        guard var frame = containerView?.bounds else {
            return CGRect.zero
        }
        
        let statusHeight = UIApplication.shared.statusBarFrame.size.height
        frame.size.height -= statusHeight
        frame.origin.y = statusHeight
        
        return frame
    }
}

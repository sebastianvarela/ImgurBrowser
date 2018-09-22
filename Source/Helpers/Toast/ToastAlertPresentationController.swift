import Foundation
import UIKit

public class ToastAlertPresentationController: UIPresentationController {
    public override func presentationTransitionWillBegin() {
        if let presentedView = presentedView {
            containerView?.addSubview(presentedView)
        }
    }
}

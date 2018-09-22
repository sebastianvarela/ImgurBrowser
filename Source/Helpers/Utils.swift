import CoreGraphics
import Foundation

public func NSLocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}

public func presentToast(level: ToastAlertLevel, message: String) {
    AppDelegate.shared.dependencies.toastManager += ToastAlert(level: level, message: message)
}

public func delay(_ delay: Double, closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: closure)
}

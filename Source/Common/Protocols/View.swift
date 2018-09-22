import Foundation

public protocol View: class, AlertPresentable, ToastPresentable, SpinnerViewAvailable {
    func dismiss(animated flag: Bool)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
    func showSystemSettings(completion: (() -> Void)?)

    var hideNavigationBar: Bool { get }
}

public protocol AlertPresentable {
    typealias AlertAction = () -> Void
    func presentAlert(title: String, subTitle: String, stringLocation: String, okAction: View.AlertAction?)
}

public extension AlertPresentable {
    func presentAlert(title: String, subTitle: String, file: String = #file, line: Int = #line, okAction: View.AlertAction? = nil) {
        let stringLocation = "\((file as NSString).lastPathComponent):L\(line)"
        presentAlert(title: title, subTitle: subTitle, stringLocation: stringLocation, okAction: okAction)
    }
}

public protocol ToastPresentable {
    func presentToast(message: String, level: ToastAlertLevel)
}

public extension ToastPresentable {
    func presentToast(message: String, level: ToastAlertLevel = .info) {
        AppDelegate.shared.dependencies.toastManager += ToastAlert(level: level, message: message)
    }
}
    
public protocol SpinnerViewAvailable {
    func showGlobalSpinnerView()
    func hideGlobalSpinnerView()
}

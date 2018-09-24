import Foundation
import Power
import ReactiveSwift
import Result

public class DefaultLoginPresenter: LoginPresenter {
    private weak var view: LoginView?
    private let interactor: LoginInteractor
    private let wireframe: RootWireframe
    private var showRequestErrors = true

    public init(view: LoginView, interactor: LoginInteractor, wireframe: RootWireframe) {
        self.view = view
        self.interactor = interactor
        self.wireframe = wireframe
    }
    
    public func viewDidLoad() {
        interactor.loginSignal.observeValuesOnUIScheduler(processLoginEvent)
        prepareRequest()
    }

    // MARK: - LoginPresenter methods

    public func requestDidStart() {
        view?.showGlobalSpinnerView()
    }
    
    public func requestDidEnd() {
        view?.hideGlobalSpinnerView()
    }
    
    public func requestDidFail(error: Error) {
        guard showRequestErrors else {
            return
        }
        logError("Request did fail with error: \(error.localizedDescription)")
        
        view?.hideGlobalSpinnerView()
        view?.presentAlert(title: NSLocalizedString("General.Alert.ErrorTitle"),
                           subTitle: NSLocalizedString("General.Alert.ErrorBody")) {
                            self.view?.dismiss(animated: true)
        }
    }
    
    public func shouldLoad(url: URL) -> Bool {
        logTrace("Try to loading: \(url)")
        
        let shouldLoad = interactor.shouldLoad(url: url)
        showRequestErrors = shouldLoad
        return shouldLoad
    }
    
    // MARK: - Private methods
    
    private func processLoginEvent(event: LoginEvent) {
        switch event {
        case .userCompleteLogin:
            view?.dismiss(animated: true)
        case .invalidCallback:
            view?.presentAlert(title: NSLocalizedString("Login.Alert.CallbackErrorTitle"),
                               subTitle: NSLocalizedString("Login.Alert.CallbackErrorBody")) {
                                self.view?.dismiss(animated: true)
            }
        case .userDeclineAccess:
            view?.presentAlert(title: NSLocalizedString("Login.Alert.UserDeclineAccessTitle"),
                               subTitle: NSLocalizedString("Login.Alert.UserDeclineAccessBody")) {
                                self.view?.dismiss(animated: true)
            }
        }
    }
    
    private func prepareRequest() {
        showRequestErrors = true
        self.view?.showGlobalSpinnerView()
        interactor.requestAuthorizationUrl()
            .observe(on: UIScheduler())
            .onProcessError(showOn: view, wireframe: wireframe)
            .startWithValues { url in
                self.view?.hideGlobalSpinnerView()
                self.view?.load(request: URLRequest(url: url))
            }
    }
}

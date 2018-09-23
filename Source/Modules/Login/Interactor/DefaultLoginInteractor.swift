import Foundation
import Power
import ReactiveSwift
import Result

public class DefaultLoginInteractor: LoginInteractor {
    
    private let userController: UserController
    private let environmentController: EnvironmentController
    
    public init(userController: UserController, environmentController: EnvironmentController) {
        self.userController = userController
        self.environmentController = environmentController
        
        (loginSignal, loginObserver) = Signal.pipe()
	}

    // MARK: - LoginInteractor methods

    private let loginObserver: Signal<LoginEvent, NoError>.Observer
    public var loginSignal: Signal<LoginEvent, NoError>

    public func shouldLoad(url: URL) -> Bool {
        guard let callbackUrl = ConstantKey.ImgurOauth2CallbackUrl.url else {
            logWarning("There is a problem with callback url constant")
            return true
        }
        if url.starts(with: callbackUrl), let urlAnchor = url.anchor {
            logTrace("Processing callback URL 👀")
            let params = URL.processQuery(query: urlAnchor)
            logTrace(params)
            //TODO: Process, by now assume its ok!
            userController.userLogged.swap(User(name: "Fulanito"))
            loginObserver.send(value: .userCompleteLogin)
            return false
        }
        if url.starts(with: callbackUrl), url.query == "error=access_denied" {
            logWarning("The user decline access")
            loginObserver.send(value: .userDeclineAccess)
            return false
        }
        return true
    }
    
    public func requestAuthorizationUrl() -> SignalProducer<URL, RequestingAuthorizationUrlError> {
        return SignalProducer { observer, _ in
            observer.send(value: self.environmentController.authorizationUrl)
            observer.sendCompleted()
        }
    }
    
    // MARK: - Private methods
}

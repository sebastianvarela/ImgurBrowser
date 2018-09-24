import Foundation
import Power
import ReactiveSwift
import Result

public protocol UserController {
    var userLogged: MutableProperty<User?> { get }
    
    func validateOauth(params: String) -> SignalProducer<Bool, NoError>
    func logout()
}

public class DefaultUserController: UserController {
    private let networkController: NetworkController
    private let queue = QueueScheduler(targeting: DispatchQueue(label: "net.s3ba.ImgurBrowser.UserController", qos: .userInitiated))

    public init(networkController: NetworkController) {
        self.networkController = networkController
    }
    
    // MARK: UserController methods
    
    public var userLogged = MutableProperty<User?>(nil)
    
    public func validateOauth(params: String) -> SignalProducer<Bool, NoError> {
        let query = URL.processQuery(query: params).reduce(into: [String: String?]()) { $0[$1.name] = $1.value }
        
        guard let refreshToken = query["refresh_token"] as? String else {
            return SignalProducer(value: false)
        }
        
        let task = NetworkTokenTask(refreshToken: refreshToken,
                                    clientId: ConstantKey.ImgurClientId.rawValue,
                                    clientSecret: ConstantKey.ImgurClientSecret.rawValue)
        
        return SignalProducer { observer, lifetime in
            lifetime += self.networkController.execute(task: task)
                .start(on: self.queue)
                .startWithResult { result in
                    switch result {
                    case .failure(let error):
                        logError("Could not validate OAuth2: \(error)")
                        observer.send(value: false)
                    case .success(let token):
                        let user = User(id: token.account_id, name: token.account_username)
                        self.userLogged.swap(user)
                        observer.send(value: true)
                    }
                }
        }
    }
    
    public func logout() {
        userLogged.swap(nil)
    }
    
    // MARK: Private methods
    
}

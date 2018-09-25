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
    private let keychainWrapper: KeychainWrapper
    private let queue = QueueScheduler(targeting: DispatchQueue(label: "net.s3ba.ImgurBrowser.UserController", qos: .userInitiated))

    public init(networkController: NetworkController, keychainWrapper: KeychainWrapper) {
        self.networkController = networkController
        self.keychainWrapper = keychainWrapper
        
        reloadUserFromKeychain()
    }
    
    // MARK: UserController methods
    
    public var userLogged = MutableProperty<User?>(nil)
    
    public func validateOauth(params: String) -> SignalProducer<Bool, NoError> {
        let query = URL.processQuery(query: params).reduce(into: [String: String?]()) { $0[$1.name] = $1.value }
        
        guard let refreshToken = query["refresh_token"] as? String else {
            return SignalProducer(value: false)
        }
        
        let tokenTask = NetworkTokenTask(refreshToken: refreshToken)
        
        return SignalProducer { observer, lifetime in
            lifetime += self.networkController.execute(task: tokenTask)
                .start(on: self.queue)
                .startWithResult { result in
                    switch result {
                    case .failure(let error):
                        logError("Could not validate OAuth2: \(error)")
                        observer.send(value: false)
                    case .success(let token):
                        self.processToken(token: token)
                        observer.send(value: true)
                    }
                }
        }
    }
    
    public func logout() {
        userLogged.swap(nil)
        keychainWrapper.delete(service: .keychainService, account: .keychainUser)
    }
    
    // MARK: Private methods
 
    private func reloadUserFromKeychain() {
        guard let userData = keychainWrapper.read(dataFromService: .keychainService, andAccount: .keychainUser),
            let user = try? JSONDecoder().decode(User.self, from: userData) else {
                return
        }
        userLogged.swap(user)
        
        // REQUEST NEW ACCESS_TOKEN
        let tokenTask = NetworkTokenTask(refreshToken: user.refreshToken)
        networkController.execute(task: tokenTask)
            .start(on: queue)
            .startWithResult { result in
                switch result {
                case .failure(let error):
                    logError("Could not request access-token. ▶️ Error: \(error)")
                    self.logout()
                    
                case .success(let token):
                    self.processToken(token: token)
                }
            }
    }
    
    private func processToken(token: NetworkToken) {
        let user = User(id: token.accountId, username: token.accountUsername, refreshToken: token.refreshToken)
        self.userLogged.swap(user)
        self.networkController.accessToken.swap(token.accessToken)
        
        if let userData = try? JSONEncoder().encode(user) {
            self.keychainWrapper.save(userData, inService: .keychainService, andAccount: .keychainUser)
        }
    }
}

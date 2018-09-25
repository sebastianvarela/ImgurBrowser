import Foundation
import Power

public struct NetworkTokenTask: NetworkTask {
    public init(refreshToken: String) {
        self.refreshToken = refreshToken
        self.clientId = ConstantKey.ImgurClientId.rawValue
        self.clientSecret = ConstantKey.ImgurClientSecret.rawValue
    }
    
    public typealias OutputType = NetworkToken

    public let refreshToken: String
    public let clientId: String
    public let clientSecret: String
    
    public var needAuth: Bool { return false }
    public var contentType: NetworkContentType {
        let body = ["refresh_token": refreshToken,
                    "client_id": clientId,
                    "client_secret": clientSecret,
                    "grant_type": "refresh_token"]
        return .formURLEncoded(body: body)
    }
    public var method: NetworkMethod { return .post }
    public var path: String { return "/oauth2/token" }
}

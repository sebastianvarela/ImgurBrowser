import Foundation
import Power

public protocol EnvironmentController {
    var endpoint: URL { get }
    var authorizationUrl: URL { get }
    var apiBase: URL { get }
}

public class DefaultEnvironmentController: EnvironmentController {
    public init() {
        
    }
    
    public var endpoint: URL {
        var components = URLComponents()
        components.scheme = ConstantKey.ImgurApiScheme.rawValue
        components.host = ConstantKey.ImgurApiHost.rawValue
        guard let url = components.url else {
            fatalError("Bad URL components")
        }
        return url
    }
    
    public var authorizationUrl: URL {
        var components = URLComponents()
        components.scheme = ConstantKey.ImgurApiScheme.rawValue
        components.host = ConstantKey.ImgurApiHost.rawValue
        components.queryItems = [URLQueryItem(name: "client_id", value: ConstantKey.ImgurClientId.rawValue),
                                 URLQueryItem(name: "response_type", value: "token")]
        components.path = "/oauth2/authorize"
        guard let url = components.url else {
            fatalError("Bad URL components")
        }
        return url
    }
    
    public var apiBase: URL {
        return endpoint.appendingPathComponent("/3/")
    }
}

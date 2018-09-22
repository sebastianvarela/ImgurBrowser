import Foundation

public protocol EnvironmentController {
    var endpoint: URL { get }
    var apiBase: URL { get }
}

public class DefaultEnvironmentController: EnvironmentController {
    public init() {
        
    }
    
    public var endpoint: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.port = 443
        components.host = "api.imgur.com"
        guard let url = components.url else {
            fatalError("Bad URL components")
        }
        return url
    }
    
    public var apiBase: URL {
        return endpoint.appendingPathComponent("/3/")
    }
}

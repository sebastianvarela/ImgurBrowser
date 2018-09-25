import Foundation
import Power

public protocol NetworkTask: CustomStringConvertible {
    associatedtype OutputType: Decodable

    var needAuth: Bool { get }
    var method: NetworkMethod { get }
    var contentType: NetworkContentType { get }
    var path: String { get }
    var body: JSON { get }
    var headers: JSON { get }
}

public extension NetworkTask {
    public var needAuth: Bool { return true }
    public var method: NetworkMethod { return .get }
    public var body: JSON { return [:] }
    public var headers: JSON { return [:] }
    
    // MARK: - CustomStringConvertible
    public var description: String {
        return "\(method.rawValue) \(path)"
    }
}

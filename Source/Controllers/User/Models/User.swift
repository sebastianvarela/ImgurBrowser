import Foundation
import Power

public struct User: Codable, ViewModel {
    public let id: Int
    public let username: String
    public let refreshToken: String
    
    public var avatarUrl: URL? {
        return URL(string: ConstantKey.AvatarBaseUrl.rawValue.replacingOccurrences(of: "{{USERNAME}}", with: username))
    }
}

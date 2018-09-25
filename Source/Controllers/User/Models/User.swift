import Foundation

public struct User: Codable, ViewModel {
    public let id: Int
    public let username: String
    public let refreshToken: String
}

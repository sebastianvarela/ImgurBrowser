import Foundation

public struct Response<T: Codable>: Codable {
    public let data: T
    public let success: Bool
    public let status: Int
}

import Foundation

public struct Image: Codable, Equatable, ViewModel {
    public let id: String
    public let type: String
    public let width: Int
    public let height: Int
    public let size: Int
    public let deletehash: String
    public let name: String?
    public let link: URL
}

public func == (lhs: Image, rhs: Image) -> Bool {
    return lhs.id == rhs.id
}

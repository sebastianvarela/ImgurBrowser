import Foundation

public struct ImgurError: Codable, CustomStringConvertible {
    public let error: ImgurErrorDetail
    public let request: String
    public let method: String
    
    public struct ImgurErrorDetail: Codable {
        public let code: Int
        public let message: String
        public let type: String
    }
    
    public var description: String {
        return "\(error.code) - \(error.message) (\(error.type) @ \(method) \(request))"
    }
}

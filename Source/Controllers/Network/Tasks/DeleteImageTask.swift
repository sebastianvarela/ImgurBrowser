import Foundation

public struct DeleteImageTask: NetworkTask {
    public typealias OutputType = Response<Empty>
    
    public let image: Image
    
    public var contentType: NetworkContentType { return .none }
    public var method: NetworkMethod { return .delete }
    public var path: String { return "/3/image/\(image.id)" }
}

import Foundation

public struct UploadImageTask: NetworkTask {
    public typealias OutputType = Response<Empty>
    
    public let attachment: AttachmentViewModel
    
    public var contentType: NetworkContentType {
        return .form(body: ["image": attachment.base64Content], boundary: "ASFKJASKFJASKFJAKSFJASKFJ")
    }
    public var method: NetworkMethod { return .post }
    public var path: String { return "/3/image" }
}

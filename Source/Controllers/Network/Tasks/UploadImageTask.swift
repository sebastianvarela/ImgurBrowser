import Foundation

public struct UploadImageTask: NetworkTask {
    public typealias OutputType = Response<Empty>
    
    public let attachment: AttachmentViewModel
    
    public var contentType: NetworkContentType {
        let body = ["image": attachment.base64Content,
                    "type": "base64"]
        return .formURLEncoded(body: body)
    }
    public var method: NetworkMethod { return .post }
    public var path: String { return "/3/image" }
}

import Foundation
import Power

public struct RetrieveImagesTask: NetworkTask {
    public typealias OutputType = Response<[Image]>

    public let page: Int

    public var contentType: NetworkContentType {
        return .none
    }
    public var method: NetworkMethod { return .get }
    public var path: String { return "/3/account/me/images/\(page)" }
}

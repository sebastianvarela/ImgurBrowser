import Foundation
import Power
import UIKit

public class AttachmentViewModel {
    public enum ExportType {
        case jpeg(compressionQuality: CGFloat)
        case png
    }
    
    public enum `Type` {
        case image(image: UIImage, exportType: ExportType)
        case video(mediaURL: URL, fileSize: Int64)
    }
    
    public let type: Type
    
    public init(type: Type) {
        self.type = type
    }
    
    public lazy var resourceURL: URL = {
        switch type {
        case .image:
            let fileName = "\(ProcessInfo.processInfo.globallyUniqueString).\(fileExtension)"
            let filePath = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
            if let bytes = bytes {
                _ = try? bytes.write(to: filePath, options: [.atomic])
            }
            return filePath
    
        case .video(let mediaURL, _):
            return mediaURL
        }
    }()
    
    public var fileExtension: String {
        switch type {
        case .image(_, .jpeg):
            return "jpg"
        case .image(_, .png):
            return "png"
        case .video(let mediaURL, _):
            return mediaURL.pathExtension.lowercased()
        }
    }
    
    public lazy var contentType: String = {
        switch type {
        case .image(_, .jpeg):
            return "image/jpeg"
        case .image(_, .png):
            return "image/png"
        case .video(let mediaURL, _):
            return "video/quicktime"
        }
    }()
    
    public lazy var base64Content: String = {
        guard let bytes = self.bytes else {
            return ""
        }
        return bytes.base64EncodedString(options: .endLineWithCarriageReturn)
    }()
    
    public lazy var previewSize: Int64? = {
        switch self.type {
        case .image:
            return self.size
        case .video:
            return self.size
        }
    }()
    
    public lazy var size: Int64? = {
        switch self.type {
        case .image:
            guard let exportedImage = self.bytes else {
                return nil
            }
            return Int64(exportedImage.count)
        case .video(_, let fileSize):
            return fileSize
        }
    }()
    
    public var isVideo: Bool {
        if case .video(_, _) = type {
            return true
        }
        return false
    }
    
    public var isImage: Bool {
        if case .image(_, _) = type {
            return true
        }
        return false
    }
    
    // MARK: Private methods
    
    private lazy var bytes: Data? = {
        switch self.type {
        case .image(let image, let exportAs):
            switch exportAs {
            case .jpeg(let compressionQuality):
                return image.jpegData(compressionQuality: compressionQuality)
            case .png:
                return image.pngData()
            }
        case .video(let mediaURL, _):
            return (try? Data(contentsOf: URL(fileURLWithPath: mediaURL.path)))
        }
    }()
}

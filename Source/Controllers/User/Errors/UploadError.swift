import Foundation

public enum UploadError: Error {
    case failed
    
    public static func map(error: NetworkError) -> UploadError {
        return .failed
    }
}

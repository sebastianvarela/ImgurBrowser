import Foundation

public enum DeleteError: Error {
    case failed
    
    public static func map(error: NetworkError) -> DeleteError {
        return .failed
    }
}

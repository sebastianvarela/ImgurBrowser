import Foundation

public enum FetchImagesError: Error {
    case failed
    
    public static func map(error: NetworkError) -> FetchImagesError {
        return .failed
    }
}

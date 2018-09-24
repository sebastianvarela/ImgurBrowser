import Foundation

public enum NetworkError: Error {
    case requestError
    case parseError
    case internalError
    case badResponse
}

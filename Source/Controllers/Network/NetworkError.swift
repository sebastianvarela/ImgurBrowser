import Foundation

public enum NetworkError: Error {
    case tokenMissing
    case requestError
    case parseError
    case internalError
    case badResponse
}

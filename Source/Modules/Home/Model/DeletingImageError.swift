import Foundation

public enum DeletingImageError: ProcessError {
    case failed
    
    public var title: String {
        return NSLocalizedString("General.Alert.ErrorTitle")
    }
    
    public var subTitle: String {
        switch self {
        case .failed:
            return NSLocalizedString("General.Alert.ErrorBody")
        }
    }
    
    public var action: ProcessErrorAction {
        return .nothing
    }
    
    public static func map(error: DeleteError) -> DeletingImageError {
        switch error {
        case .failed:
            return .failed
        }
    }
}

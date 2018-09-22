import Foundation

public protocol VersionsController {
    var readableAppVersion: String { get }
    var appVersion: String { get }
}

public class DefaultVersionsController: VersionsController {
    private let environmentController: EnvironmentController
    
    public init(environmentController: EnvironmentController) {
        self.environmentController = environmentController
        readableAppVersion = Bundle.main.applicationReadableVersion
    }
    
    public let readableAppVersion: String
    
    public var appVersion: String {
        return Bundle.main.appVersion
    }
}

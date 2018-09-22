import Foundation

public protocol ProcessError: Error {
    var title: String { get }
    var subTitle: String { get }
    var action: ProcessErrorAction { get }
}

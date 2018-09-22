import Foundation
import ReactiveSwift

public protocol ViewModel {
    var selected: Bool { get }
}

public extension ViewModel {
    public var selected: Bool {
        return false
    }
}

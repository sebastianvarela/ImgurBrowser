import Foundation
import ReactiveSwift
import Result

public protocol HomeInteractor: Interactor {
    var userLogged: MutableProperty<Bool> { get }
}

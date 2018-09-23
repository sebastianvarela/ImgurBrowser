import Foundation
import ReactiveSwift
import Result

public protocol LoginInteractor: Interactor {
    var loginSignal: Signal<LoginEvent, NoError> { get }
    
    func shouldLoad(url: URL) -> Bool
    func requestAuthorizationUrl() -> SignalProducer<URL, RequestingAuthorizationUrlError>
}

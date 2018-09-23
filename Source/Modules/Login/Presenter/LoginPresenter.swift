import Foundation
import ReactiveSwift
import Result

public protocol LoginPresenter: Presenter {
    func requestDidStart()
    func requestDidEnd()
    func requestDidFail(error: Error)
    func shouldLoad(url: URL) -> Bool
}

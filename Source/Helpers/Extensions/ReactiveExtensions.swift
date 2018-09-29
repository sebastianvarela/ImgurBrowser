import Foundation
import Power
import ReactiveSwift
import Result

public extension SignalProducer where Error: ProcessError {
    public func onProcessError(showOn view: View?, wireframe: RootWireframe) -> SignalProducer<Value, NoError> {
        return observe(on: UIScheduler())
            .onFailed { error in
                view?.hideGlobalSpinnerView()
                view?.presentAlert(title: error.title, subTitle: error.subTitle) {
                    switch error.action {
                    case .closeApp:
                        wireframe.close()
                    case .nothing:
                        break
                    }
                }
            }.demoteError()
    }
}

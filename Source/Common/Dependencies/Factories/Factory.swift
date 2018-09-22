import Foundation
import UIKit

public class Factory {
    public init() {
    }
    
    public func createVC<P, VC>() -> VC where VC: BaseViewController<P> {
        let vc: VC = UIViewController.initFromStoryboard()
        return vc
    }
    
    public func createView<VM, V>(viewModel: VM) -> V where V: BaseView<VM> {
        let nibName = String(describing: V.self)
        guard let view: V = Bundle.main.loadNibNamed(nibName, owner: nil, options: nil)?.first as? V else {
            fatalError("Can not create view with nib name: \(nibName)")
        }
        view.viewModel.swap(viewModel)
        
        return view
    }
}

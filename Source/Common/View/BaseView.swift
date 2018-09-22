import Foundation
import ReactiveSwift
import UIKit

public class BaseView<VM: ViewModel>: UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        observeChanges()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        observeChanges()
    }
    
    // MARK: - Public methods
    
    public var viewModel = MutableProperty<VM?>(nil)
    
    public func setupGUI(viewModel: VM) {
        fatalError("Override this method")
    }
    
    // MARK: - Private methods
    
    private func observeChanges() {
        viewModel.signal
            .skipNil()
            .observeValuesOnUIScheduler(setupGUI)
    }
}

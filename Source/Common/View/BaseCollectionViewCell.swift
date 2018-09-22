import Foundation
import ReactiveSwift
import UIKit

public class BaseCollectionViewCell<VM: ViewModel>: UICollectionViewCell, Cell {
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
            .observe(on: UIScheduler())
            .observeValues(setupGUI)
    }
}

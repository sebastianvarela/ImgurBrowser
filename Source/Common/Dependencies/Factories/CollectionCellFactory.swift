import Foundation
import UIKit

public class CollectionCellFactory {
    private let collectionView: UICollectionView
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    public func createCell<VM, C>(viewModel: VM, indexPath: IndexPath) -> C
        where C: BaseCollectionViewCell<VM> {
            let cell: C = collectionView.dequeueReusableCell(indexPath: indexPath)
            cell.viewModel.swap(viewModel)
            
            return cell
    }
}

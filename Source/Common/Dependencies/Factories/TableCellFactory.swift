import Foundation
import UIKit

public class TableCellFactory {
    private let tableView: UITableView
    
    public init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    public func createCell<VM, C>(viewModel: VM, indexPath: IndexPath, totalRows: Int? = nil) -> C
        where C: BaseTableViewCell<VM> {
            let cell: C = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.rowIndex = indexPath.row
            cell.totalRowsInSection = totalRows
            cell.configureBorder()
            cell.viewModel.swap(viewModel)
            
            return cell
    }

    public func createHeaderFooter<VM, H>(viewModel: VM) -> H
        where H: BaseTableHeaderView<VM> {
            let header: H = tableView.dequeueReusableHeaderFooterView()
            header.viewModel.swap(viewModel)
            
            return header
    }
}

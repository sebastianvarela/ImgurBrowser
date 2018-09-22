import Cartography
import Foundation
import Power
import ReactiveSwift
import Result
import UIKit

public class BaseTableViewCell<VM: ViewModel>: UITableViewCell, Cell {
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        observeChanges()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        observeChanges()
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        refreshBorder()
    }
    
    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        topContentLine.backgroundColor = .imgurBrowserGrayLine
    }
    
    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        topContentLine.backgroundColor = .imgurBrowserGrayLine
    }
    
    // MARK: - Public methods
    
    public var rowIndex: Int?
    public var totalRowsInSection: Int?
    public var applyRoundBorders: Bool {
        return false
    }
    
    public var viewModel = MutableProperty<VM?>(nil)

    public func setupGUI(viewModel: VM) {
        fatalError("Override this method")
    }
    
    public func changeSelectedImage(selected: Bool) {
        
    }
    
    public func configureBorder() {
        guard let rowIndex = rowIndex, let totalRowsInSection = totalRowsInSection, applyRoundBorders else {
            return
        }
        
        switch rowIndex {
        case 0 where totalRowsInSection > 1:
            borderType = .top
            topContentLine.isHidden = true
        case 0 where totalRowsInSection == 1:
            borderType = .both
            topContentLine.isHidden = true
        case totalRowsInSection - 1:
            borderType = .bottom
            topContentLine.isHidden = false
        default:
            borderType = .none
            topContentLine.isHidden = false
        }
        logDebug("Applying style to VM \"\(viewModel.value.textualDescription)\". BORDER: \(borderType) - TOP LINE: \(topContentLine.isHidden)")
    }
    
    // MARK: - Private methods

    private func observeChanges() {
        viewModel.signal
            .skipNil()
            .observe(on: UIScheduler())
            .observeValues(setupGUI)

        viewModel.signal
            .skipNil()
            .map { $0.selected }
            .observeValuesOnUIScheduler(changeSelectedImage)
    }
    
    private var borderType = TableViewCellBorderType.none { didSet { refreshBorder() } }

    private func refreshBorder() {
        switch borderType {
        case .none:
            clipsToBounds = true
            layer.cornerRadius = 0
        case .top:
            clipsToBounds = true
            if #available(iOS 11.0, *) {
                layer.cornerRadius = 8
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            }
        case .bottom:
            clipsToBounds = true
            if #available(iOS 11.0, *) {
                layer.cornerRadius = 8
                layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        case .both:
            clipsToBounds = true
            if #available(iOS 11.0, *) {
                layer.cornerRadius = 8
                layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    private lazy var topContentLine: UIView = {
        let line = UIView()
        line.backgroundColor = .imgurBrowserGrayLine
        line.isHidden = true
        addSubview(line)
        constrain(self, line) { cnt, lin in
            lin.height == 1
            lin.leading == cnt.leading + 10
            lin.trailing == cnt.trailing - 10
            lin.top == cnt.top
        }
        return line
    }()
    
    private enum TableViewCellBorderType {
        case none
        case top
        case bottom
        case both
    }
}

import Foundation
import Kingfisher
import ReactiveSwift
import Result
import UIKit

public class HomeImageCell: BaseTableViewCell<Image> {
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var resolutionLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!

    public override func setupGUI(viewModel: Image) {
        cellImageView.image = UIImage(named: "ImagePlaceholder")
        cellImageView.kf.setImage(with: viewModel.link,
                                  placeholder: UIImage(named: "ImagePlaceholder"),
                                  options: nil,
                                  progressBlock: nil,
                                  completionHandler: nil)
        
        nameLabel.text = viewModel.name
        resolutionLabel.text = "\(viewModel.width)x\(viewModel.height)"
        sizeLabel.text = "\(viewModel.size) Bytes"
    }
}

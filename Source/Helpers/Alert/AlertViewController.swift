import Foundation
import UIKit

public class AlertViewController: UIViewController, AlertView {
    @IBOutlet private weak var titleContainer: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var stackContainer: UIView!
    @IBOutlet private weak var stackAlert: UIStackView!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGUI()
    }
    
    public func setupAlert(title: String, subTitle: String, okAction: View.AlertAction?) {
        titleLabel.text = title
        subTitleLabel.text = subTitle
        okButton.touchSignal
            .observeValues { [weak self] in
                self?.dismiss(animated: true) { okAction?() }
            }
    }
    
    // MARK: - AlertView methods
    
    public var containerSize: CGSize {
        return stackContainer.bounds.size
    }
    
    // MARK: - Private methods
    
    private func setupGUI() {
        titleLabel.textColor = .imgurBrowserWhiteText
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleContainer.backgroundColor = .imgurBrowserGreenBackground

        subTitleLabel.font = .systemFont(ofSize: 17)
        subTitleLabel.textColor = .imgurBrowserGrayText
        
        okButton.setTitle(NSLocalizedString("General.Alert.AcceptButton"), for: .normal)
        okButton.setTitleColor(.imgurBrowserWhiteText, for: .normal)
        okButton.backgroundColor = .imgurBrowserGreenBackground
        okButton.titleLabel?.font = .systemFont(ofSize: 16)
        
        stackContainer.layer.cornerRadius = 5
        stackContainer.clipsToBounds = true
    }
}

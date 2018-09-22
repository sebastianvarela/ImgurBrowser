import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit

public class HomeViewController: BaseViewController<DefaultHomePresenter>, HomeView {
       
    public override func setupGUI() {
        title = NSLocalizedString("Home.Title")
    }

    // MARK: - HomeView methods

    // MARK: - Private methods
}

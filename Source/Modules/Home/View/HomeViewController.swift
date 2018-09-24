import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit

public class HomeViewController: BaseViewController<DefaultHomePresenter>, HomeView {
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loginInfoLabel: UILabel!

    @IBOutlet private weak var userInfoWrapperView: UIView!
    @IBOutlet private weak var userInfoLabel: UILabel!

    @IBOutlet private weak var photosTable: UITableView!

    public override var navigationForegroundColor: UIColor {
        return .imgurBrowserWhiteText
    }
    
    public override func setupGUI() {
        title = NSLocalizedString("Home.Title")
        
        view.backgroundColor = .imgurBrowserGreenBackground
        
        loginInfoLabel.text = NSLocalizedString("Login.LoginInfo")
        loginInfoLabel.textColor = .imgurBrowserWhiteText

        loginButton.setTitle(NSLocalizedString("Login.LoginButton"), for: .normal)
        loginButton.setTitleColor(.imgurBrowserBlackText, for: .normal)
        loginButton.backgroundColor = .imgurBrowserYellowBackground
        loginButton.layer.cornerRadius = 8
        loginButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        loginButton.onTouchAction(presenter.login)
        loginButton.reactive.isEnabled <~ presenter.userLogged.isNil
        
        userInfoWrapperView.reactive.isHidden <~ presenter.userLogged.isNil
        userInfoWrapperView.backgroundColor = .imgurBrowserGreenBackground
        userInfoLabel.textColor = .imgurBrowserWhiteText
        userInfoLabel.reactive.text <~ presenter.userLogged.map(mapGreeting)
        photosTable.reactive.isHidden <~ presenter.userLogged.isNil
        
        navigationItem.leftBarButtonItem = editBarButton
        navigationItem.rightBarButtonItem = logoutBarButton
        editButtonAction.onCompletedAction(presenter.enableEditMode)
        logoutBarButtonAction.onCompletedAction(presenter.logout)
    }

    // MARK: - HomeView methods
    
    // MARK: - Private methods
    
    private func mapGreeting(user: User?) -> String {
        if let user = user {
            return NSLocalizedString("Login.UserInfoLabel").replacingOccurrences(of: "{{USER}}", with: user.name)
        }
        return ""
    }
    
    private lazy var editBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit)
        button.reactive.pressed = CocoaAction(editButtonAction)
        return button
    }()
    
    private lazy var logoutBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Login.LogoutButton"), style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        button.reactive.pressed = CocoaAction(logoutBarButtonAction)
        return button
    }()
    
    private lazy var editButtonAction: Action<Void, Void, NoError> = {
        let enabledIf = Property(presenter.userLogged.isNotNil)
        return Action<Void, Void, NoError>(enabledIf: enabledIf) { _ in return SignalProducer(value: ()) }
    }()

    private lazy var logoutBarButtonAction: Action<Void, Void, NoError> = {
        let enabledIf = Property(presenter.userLogged.isNotNil)
        return Action<Void, Void, NoError>(enabledIf: enabledIf) { _ in return SignalProducer(value: ()) }
    }()
}

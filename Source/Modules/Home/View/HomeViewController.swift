import Kingfisher
import Power
import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit

public class HomeViewController: BaseViewController<DefaultHomePresenter>, HomeView, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var loginInfoLabel: UILabel!

    @IBOutlet private weak var userInfoWrapperView: UIView!
    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var userInfoLabel: UILabel!

    @IBOutlet private weak var imagesTable: UITableView!
    private let refreshControl = UIRefreshControl()

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
        userImageView.cropAsCircleWithBorder(borderColor: .white, strokeWidth: 3)
        userInfoLabel.textColor = .imgurBrowserWhiteText
        userInfoLabel.reactive.text <~ presenter.userLogged.map(mapGreeting)
        
        presenter.userLogged.signal.observeValuesOnUIScheduler(setUserImage)
        
        imagesTable.reactive.isHidden <~ presenter.userLogged.isNil
        imagesTable.refreshControl = refreshControl
        imagesTable.dataSource = self
        imagesTable.delegate = self
        imagesTable.register(HomeImageCell.self)
        imagesTable.rowHeight = UITableView.automaticDimension
        imagesTable.estimatedRowHeight = 100
        
        refreshControl.reactive.refresh = CocoaAction(presenter.refreshAction)
        
        navigationItem.leftBarButtonItem = editBarButton
        navigationItem.rightBarButtonItem = logoutBarButton
        editButtonAction.onCompletedAction(presenter.enableEditMode)
        logoutBarButtonAction.onCompletedAction(presenter.logout)
        
        presenter.images.signal.onValueReceivedOnUIScheduler(imagesTable.reloadData)
    }

    // MARK: - HomeView methods
    
    // MARK: - UITableViewDataSource
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.images.value.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = presenter.images.value[indexPath.row]
        let cell: HomeImageCell = cellFactory.createCell(viewModel: image, indexPath: indexPath, totalRows: presenter.images.value.count)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let image = presenter.images.value[indexPath.row]
        presenter.show(image: image)
    }
    
    // MARK: - Private methods
    
    private func mapGreeting(user: User?) -> String {
        if let user = user {
            return NSLocalizedString("Login.UserInfoLabel").replacingOccurrences(of: "{{USER}}", with: user.username)
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
    
    private lazy var cellFactory: TableCellFactory = {
        return TableCellFactory(tableView: self.imagesTable)
    }()
    
    private func setUserImage(user: User?) {
        if let user = user {
            self.userImageView.kf.setImage(with: user.avatarUrl)
        } else {
            self.userImageView.image = nil
        }
    }
}

public extension UIImageView {
    public func cropAsCircleWithBorder(borderColor: UIColor, strokeWidth: Int) {
        let strokeWidthFloat = CGFloat(strokeWidth)
        
        var radius = min(self.bounds.width, self.bounds.height)
        var drawingRect: CGRect = self.bounds
        drawingRect.size.width = radius
        drawingRect.origin.x = (self.bounds.size.width - radius) / 2
        drawingRect.size.height = radius
        drawingRect.origin.y = (self.bounds.size.height - radius) / 2
        
        radius /= 2
        
        var path = UIBezierPath(roundedRect: drawingRect.insetBy(dx: strokeWidthFloat / 2, dy: strokeWidthFloat / 2), cornerRadius: radius)
        let border = CAShapeLayer()
        border.fillColor = UIColor.clear.cgColor
        border.path = path.cgPath
        border.strokeColor = borderColor.cgColor
        border.lineWidth = strokeWidthFloat
        layer.addSublayer(border)
        
        path = UIBezierPath(roundedRect: drawingRect, cornerRadius: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

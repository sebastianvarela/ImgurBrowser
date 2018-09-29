import Kingfisher
import Power
import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit

public class HomeViewController: BaseViewController<DefaultHomePresenter>, HomeView, UITableViewDataSource, UITableViewDelegate, PhotoLibraryPickerDelegate {
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
        
        loginInfoLabel.text = NSLocalizedString("Home.LoginInfo")
        loginInfoLabel.textColor = .imgurBrowserWhiteText

        loginButton.setTitle(NSLocalizedString("Home.LoginButton"), for: .normal)
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
        imagesTable.tableFooterView = UIView()
        imagesTable.backgroundColor = .imgurBrowserLightGrayBackground

        refreshControl.reactive.refresh = CocoaAction(presenter.refreshAction)
        
        navigationItem.leftBarButtonItem = editBarButton
        navigationItem.rightBarButtonItem = logoutBarButton
        editButtonAction.onCompletedAction(presenter.enableEditMode)
        logoutBarButtonAction.onCompletedAction(presenter.logout)
        
        presenter.images.signal.onValueReceivedOnUIScheduler(imagesTable.reloadData)
    }

    // MARK: - HomeView methods

    public func showImagePicker() {
        let alert = UIAlertController(title: NSLocalizedString("ImagePicker.SelectSource.Title"), message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ImagePicker.SelectSource.Camera"), style: .default) { _ in
            let controller = PhotoLibraryPickerController(useCameraIfPossible: true)
            controller.pickerDelegate = self
            self.present(controller, animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ImagePicker.SelectSource.Gallery"), style: .default) { _ in
            let controller = PhotoLibraryPickerController(useCameraIfPossible: false)
            controller.pickerDelegate = self
            self.present(controller, animated: true, completion: nil)
        })
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("ImagePicker.SelectSource.Cancel"), style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section == 0 else {
            return 1
        }
        return presenter.images.value.count
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 15
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.section == 0 else {
            return addImageTableViewCell
        }
        let image = presenter.images.value[indexPath.row]
        let cell: HomeImageCell = cellFactory.createCell(viewModel: image, indexPath: indexPath, totalRows: presenter.images.value.count)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell == addImageTableViewCell {
            presenter.addImage()
        } else {
            let image = presenter.images.value[indexPath.row]
            presenter.show(image: image)
        }
    }
    
    // MARK: - PhotoLibraryPickerDelegate
    
    public func photoLibraryPickerView(didSelectAttachment attachment: AttachmentViewModel) {
        logTrace("Selected attachment: \(attachment)")
    }
    
    // MARK: - Private methods
    
    private func mapGreeting(user: User?) -> String {
        if let user = user {
            return NSLocalizedString("Home.UserInfoLabel").replacingOccurrences(of: "{{USER}}", with: user.username)
        }
        return ""
    }
    
    private lazy var editBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit)
        button.reactive.pressed = CocoaAction(editButtonAction)
        return button
    }()
    
    private lazy var logoutBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: NSLocalizedString("Home.LogoutButton"), style: UIBarButtonItem.Style.plain, target: nil, action: nil)
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
    
    private lazy var addImageTableViewCell: UITableViewCell = {
        let cell = UITableViewCell()
        cell.textLabel?.textColor = .imgurBrowserGreenText
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        cell.textLabel?.text = NSLocalizedString("Home.AddImageButton")
        cell.textLabel?.textAlignment = .center
        return cell
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

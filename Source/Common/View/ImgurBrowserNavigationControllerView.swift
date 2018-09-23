import Foundation
import UIKit

public protocol ImgurBrowserNavigationControllerView {
    var navigationForegroundColor: UIColor { get }
    var hideNavigationBar: Bool { get }
    var showCloseOnNavigationBar: Bool { get }
    var hideToolbar: Bool { get }
}

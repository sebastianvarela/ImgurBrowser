import Foundation
import Kingfisher
import Power
import QuickLook

public class PreviewViewController: QLPreviewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource, ImgurBrowserNavigationControllerView {
    private let attachment: AttachmentViewModel

    public init(attachment: AttachmentViewModel) {
        self.attachment = attachment
        super.init(nibName: nil, bundle: nil)
        delegate = self
        dataSource = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: QLPreviewControllerDelegate
    
    // MARK: QLPreviewControllerDataSource
    
    public func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return PreviewItem(attachment: attachment)
    }
    
    // MARK: ImgurBrowserNavigationControllerView
    
    public var navigationForegroundColor: UIColor {
        return .imgurBrowserGreenText
    }
    
    public var hideNavigationBar: Bool {
        return false
    }
    
    public var showCloseOnNavigationBar: Bool {
        return false
    }
    
    public var hideToolbar: Bool {
        return true
    }
    
    // MARK: Private Methods
    
    private func findToolbarsInSubviews(forView view: UIView) -> [UIToolbar] {
        var toolbars: [UIToolbar] = []
        for subview in view.subviews {
            if let toolbar = subview as? UIToolbar {
                toolbars.append(toolbar)
            }
            toolbars.append(contentsOf: findToolbarsInSubviews(forView: subview))
        }
        return toolbars
    }
    
    // MARK: Internal type
    
    internal class PreviewItem: NSObject, QLPreviewItem {
        internal let previewItemURL: URL?
        internal let previewItemTitle: String?
        
        internal init(attachment: AttachmentViewModel) {
            previewItemURL = attachment.resourceURL
            previewItemTitle = NSLocalizedString("General.Preview.Title")
        }
    }
}

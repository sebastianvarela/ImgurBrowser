import Foundation
import Kingfisher
import Power
import QuickLook

public class HomePreviewViewController: QLPreviewController, QLPreviewControllerDelegate, QLPreviewControllerDataSource, ImgurBrowserNavigationControllerView {
    private let images: [Image]
    private var hiddenObservation: NSKeyValueObservation?

    public init(images: [Image]) {
        self.images = images
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
        return images.count
    }
    
    public func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let image = images[index]
        return PreviewItem(image: image)
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
}

public class PreviewItem: NSObject, QLPreviewItem {
    public let previewItemURL: URL?
    public let previewItemTitle: String?
    
    public init(image: Image) {
        previewItemURL = image.link
        previewItemTitle = image.name
    }
}

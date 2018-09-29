import Foundation
import MobileCoreServices
import UIKit

public protocol PhotoLibraryPickerDelegate: class {
    func photoLibraryPickerView(didSelectAttachment attachment: AttachmentViewModel)
}

public class PhotoLibraryPickerController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private var nativePickerController = UIImagePickerController()
    private var useCameraIfPossible: Bool

    public weak var pickerDelegate: PhotoLibraryPickerDelegate?
    
    public init(useCameraIfPossible: Bool) {
        self.useCameraIfPossible = useCameraIfPossible
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        nativePickerController = UIImagePickerController()
        if useCameraIfPossible && UIImagePickerController.isSourceTypeAvailable(.camera) {
            nativePickerController.sourceType = .camera
            nativePickerController.cameraCaptureMode = .photo
        } else {
            nativePickerController.sourceType = .photoLibrary
        }
        nativePickerController.mediaTypes = [kUTTypeImage as String]
        nativePickerController.allowsEditing = true
        nativePickerController.delegate = self
        nativePickerController.navigationBar.isTranslucent = false

        addChild(nativePickerController)
        view.addSubview(nativePickerController.view)
        nativePickerController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nativePickerController.didMove(toParent: self)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        DispatchQueue.global(qos: .userInitiated).async {
            let mediaType = info[.mediaType] as? String
            var viewModel: AttachmentViewModel?
            
            if mediaType == kUTTypeImage as String {
                var image: UIImage?
                if let editedImage = info[.editedImage] as? UIImage {
                    image = editedImage
                } else if let originalImage = info[.originalImage] as? UIImage {
                    image = originalImage
                }
                if let image = image {
                    viewModel = AttachmentViewModel(type: .image(image: image, exportType: .jpeg(compressionQuality: 0.5)))
                }
            }
            
            if mediaType == kUTTypeMovie as String {
                let mediaURL = info[.mediaURL] as? URL
                var fileSize: Int64 = 0
                if let mediaURL = mediaURL,
                   let fileAttributes = try? FileManager.default.attributesOfItem(atPath: mediaURL.path),
                   let fileSizeFromAttribute = fileAttributes[FileAttributeKey.size] as? NSNumber {
                        fileSize = fileSizeFromAttribute.int64Value
                        viewModel = AttachmentViewModel(type: .video(mediaURL: mediaURL, fileSize: fileSize))
                }
            }
            
            DispatchQueue.main.async {
                if let viewModel = viewModel {
                    self.pickerDelegate?.photoLibraryPickerView(didSelectAttachment: viewModel)
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

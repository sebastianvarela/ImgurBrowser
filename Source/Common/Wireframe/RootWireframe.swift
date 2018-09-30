import Foundation

public protocol RootWireframe: Wireframe {
    func updateGlobalNetworkActivity(visible: Bool)
    
    func presentMainView()
    func preview(attachment: AttachmentViewModel)
    func showLogin()
    func close()
}

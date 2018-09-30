import Foundation

public protocol RootWireframe: Wireframe {
    func updateGlobalNetworkActivity(visible: Bool)
    
    func presentMainView()
    func preview(images: [Image], focusOn: Int)
    func showLogin()
    func close()
}

import Cartography
import ReactiveCocoa
import ReactiveSwift
import Result
import UIKit
import WebKit

public class LoginViewController: BaseViewController<DefaultLoginPresenter>, LoginView, WKNavigationDelegate, WKUIDelegate {

    public override var hideNavigationBar: Bool {
        return true
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public override func setupGUI() {
        view.backgroundColor = UIColor.imgurBrowserDarkGrayBackground
    }

    // MARK: - LoginView methods

    public func load(request: URLRequest) {
        webview.load(request)
    }
    
    // MARK: - WKNavigationDelegate
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation) {
        presenter.requestDidStart()
    }
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        presenter.requestDidFail(error: error)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        presenter.requestDidEnd()
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            return
        }
        return decisionHandler(presenter.shouldLoad(url: url) ? .allow : .cancel)
    }
    
    // MARK: - Private methods
    
    private lazy var webview: WKWebView = {
        let webview = WKWebView()
        webview.backgroundColor = .clear
        webview.navigationDelegate = self
        webview.allowsLinkPreview = true
        webview.uiDelegate = self
        view.addSubview(webview)
        constrain(webview, view.safeAreaLayoutGuide) { webview, container in
            webview.top == container.top
            webview.bottom == container.bottom
            webview.leading == container.leading
            webview.trailing == container.trailing
        }
        return webview
    }()
}

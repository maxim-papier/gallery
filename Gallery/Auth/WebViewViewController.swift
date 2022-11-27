import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet private var authWebView: WKWebView!
    @IBAction func didTapBackwardButton() {
        dismiss(animated: true)
    }
    
    var delegate: WebViewViewControllerDelegate?
    
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        authWebView.navigationDelegate = self
        
        
        // Compose a URL for a further request
        var urlComponents =
        URLComponents(string: K.unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: K.accessKey),
            URLQueryItem(name: "redirect_uri", value: K.redirectURI),
            URLQueryItem(name: "response_type", value: K.responseType),
            URLQueryItem(name: "scope", value: K.accessScope)
        ]
        
        let url = urlComponents.url!
        
        // Load authorization page
        let request = URLRequest(url: url)
        authWebView.load(request)
        
        updateProgress()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        authWebView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        authWebView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
    }
    
    //MARK: - Observer
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
            
        } else {
            super.observeValue(
                forKeyPath: keyPath,
                of: object,
                change: change,
                context: context
            )
        }
    }
    
    private func updateProgress() {
        if authWebView.estimatedProgress < 1.0 {
            progressView.progress = Float(authWebView.estimatedProgress)
        } else {
            progressView.isHidden = true
        }
    }
    
}


// Check if a user is authorized successfully
extension WebViewViewController: WKNavigationDelegate {
    
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
    
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
        
    }
    
}


protocol WebViewViewControllerDelegate: AnyObject {
    
    func webViewViewController(
        _ vc: WebViewViewController,
        didAuthenticateWithCode code: String
    )
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}

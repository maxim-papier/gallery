import UIKit
import WebKit


final class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
    
        
    var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadWebView(url: composeAuthorizationURL())
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observerOn() // Progress bar
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        observerOff()
    }

    
    // Compose a URL for a further request
    
    private func composeAuthorizationURL() -> URL {
        
        var urlComponents = URLComponents(string: K.authURLString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: K.accessKey),
            URLQueryItem(name: "redirect_uri", value: K.redirectUri),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: K.accessScope)
        ]
        
        let url = urlComponents.url!
        return url
        
    }
    
    
    // Load authorization page
    
    private func loadWebView(url: URL) {
        
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    
    
    // MARK: - PROGRESS BAR
    
    // Add the observer
    
    private func observerOn() {
        
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil
        )
        
        updateProgress()
        
    }
    
    // Remove the observer
    
    private func observerOff() {
        
        webView.removeObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            context: nil
        )
        
    }
    
    // Progress
    
    private func updateProgress() {
        
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
   
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            
        }
    }
    
}


// MARK: - EXTENTIONS

extension WebViewViewController: WKNavigationDelegate {
 
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    )   {
        if let code = code(from: navigationAction) {
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        
    }
    
    
    // Check if navigation action was right (getting "code")
 
    private func code(from navigationAction: WKNavigationAction) -> String? {
        
        guard
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        else { return nil }
        
        return codeItem.value
        
    }
 
}


// MARK: - PROTOCOL

protocol WebViewViewControllerDelegate: AnyObject {
    
    // WebViewviewControll got the code
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    // The user taped backward button and canceled registration
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}



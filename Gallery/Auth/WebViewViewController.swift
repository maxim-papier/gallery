import UIKit
import WebKit


class WebViewViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    @IBAction private func didTapBackButton(_ sender: Any) {}
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        webView.navigationDelegate = self
        loadWebView(url: composeAuthorizationURL())
        
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
    
}


// MARK: - EXTENTIONS

extension WebViewViewController: WKNavigationDelegate {
 
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            
            decisionHandler(.cancel)
            
        } else {
            
            decisionHandler(.allow)
            
        }
        
    }
    
    
    // Check if navigation action was right (getting "code")
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItems = items.first(where: { $0.name == "code" } )
        {

            return codeItems.value
            
        } else {
            
            return nil
            
        }
                
    }
    
}


// MARK: - PROTOCOL

protocol WebViewViewControllerDelegate {
    
    // WebViewviewControll got code
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    // The user taped backward button and canceled registration
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}



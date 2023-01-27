import UIKit
import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(with request: URLRequest)
}


final class WebViewViewController: UIViewController & WebViewViewControllerProtocol {
    
    
    var presenter: WebViewPresenterProtocol?
    var delegate: WebViewViewControllerDelegate?
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    @IBAction private func didTapBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
        
    
    func load(with request: URLRequest) {
        webView.load(request)
    }

    
    
    // MARK: - PROGRESS BAR
    
    // Add the observer
    
    private func setObserver() {
        
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [ weak self] _, _ in
                 guard let self else { return }
                 self.updateProgress()
             })
        
    }
    
    
    // Progress
    
    private func updateProgress() {
        
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
        
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
            print("CODE: \(code)")
            decisionHandler(.cancel)
            self.delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            
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


protocol WebViewViewControllerDelegate: AnyObject {
    
    // WebViewViewController got the code
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    // The user taped backward button and canceled registration
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}

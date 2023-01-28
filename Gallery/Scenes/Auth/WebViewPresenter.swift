import Foundation



public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
}


final class WebViewPresenter: WebViewPresenterProtocol {
    
    
    weak var view: WebViewViewControllerProtocol?
    
    
    func viewDidLoad() {
        loadWebView(url: composeAuthURL())
        didUpdateProgressValue(0)
    }
}


extension WebViewPresenter {
    
    // Compose a URL for a further request
    
    private func composeAuthURL() -> URL {
        
        var urlComponents = URLComponents(string: K.authURL)!
        
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
        view?.load(with: request)
    }
}


// Progress logic

extension WebViewPresenter {
    
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
}

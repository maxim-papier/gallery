import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    
    func didAuthenticate()
    
}


final class AuthViewController: UIViewController {
    
    private let showWebViewSegueID = "ShowWebView"
    
    let getTokenService = OAuth2Service()
    var tokenStorage = OAuth2TokenStorage()
    
    weak var delegate: AuthViewControllerDelegate?

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard segue.identifier == showWebViewSegueID,
                let webViewViewController = segue.destination as? WebViewViewController
        else { return }
        
        webViewViewController.delegate = self
    
    }

}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
                
        getTokenService.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
                    
            switch result {
            case .success(let token):
                self.tokenStorage.token = token
                self.delegate?.didAuthenticate()
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}


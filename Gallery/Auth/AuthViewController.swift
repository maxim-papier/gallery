import UIKit

class AuthViewController: UIViewController {
    
    private let showWebViewID = "ShowWebView"
    
    let getTokenService = OAuth2Service()
    var tokenStorage = OAuth2TokenStorage()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard segue.identifier == showWebViewID,
                let webViewViewController = segue.destination as? WebViewViewController
        else { return }
        
        webViewViewController.delegate = self
    
    }

}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
                
        getTokenService.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
        
            print("RESULT \(result)")
            
            switch result {
            case .success(let token):
                self.tokenStorage.token = token
                print("SUCCESS: \(token)")
            case .failure(let error):
                print("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}

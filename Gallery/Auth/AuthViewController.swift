import UIKit

class AuthViewController: UIViewController {
    
    private let showWebViewID = "ShowWebView"

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard segue.identifier == showWebViewID,
                let webViewViewConroller = segue.destination as? WebViewViewController
        else { return }
        
        webViewViewConroller.delegate = self
    
    }

}

extension AuthViewController: WebViewViewControllerDelegate {
    
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        //TODO: process code
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
    
}

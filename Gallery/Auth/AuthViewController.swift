import UIKit

class AuthViewController: UIViewController {
    
    private let showWebViewID = "ShowWebView"
    
    @IBAction func enterButtonDidTapped(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showWebViewID {
            let webViewVC = segue.destination as? WebViewViewController
            webViewVC?.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    
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


/*
 
 Сделайте AuthViewController делегатом WebViewViewController.
 Присвоение делегата WebViewViewController можно реализовать в методе
 prepare(for segue: UIStoryboardSegue, sender: Any?).
 
 */

import UIKit
import ProgressHUD

enum SplashError: String {
    case invalidConfiguration = "Invalid Configuration"
    case failedToPrepSegue = "Failed to prepare to segue for: "
}


final class SplashViewController: UIViewController {
    
    private let showAuthScreenSegueID = "ShowAuthenticationScreen"
    private let tabBarStoryboardID = "TabBarViewController"
    
    private let getTokenService = OAuth2Service()
    private var tokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        switchToAuthOrTabBar()
    }
        
}


// MARK: - Checking if this is logged in user:

extension SplashViewController {
        
    func switchToAuthOrTabBar(tokenStorage: OAuth2TokenStorage = OAuth2TokenStorage()) {
                
        if tokenStorage.token != nil {
            // logged in
            switchToTabBarController()
        } else {
            // is NOT logged in
            performSegue(withIdentifier: showAuthScreenSegueID, sender: nil)
        }
        
    }
    
}


// MARK: - Switch to the TabBarController if user is authorized


extension SplashViewController {
    
    func switchToTabBarController() {
                
        guard let window = UIApplication.shared.windows.first else
        { fatalError(SplashError.invalidConfiguration.rawValue) }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: tabBarStoryboardID)
        
        window.rootViewController = tabBarController
        
    }
    
}

extension SplashViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showAuthScreenSegueID {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController else {
                fatalError(SplashError.failedToPrepSegue.rawValue + showAuthScreenSegueID)
            }
            
            viewController.delegate = self
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
                
        UIBlockingProgressHUD.show()
        
        getTokenService.fetchAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let token):
                    self.tokenStorage.token = token
                    self.didAuthenticate()
                case .failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                }
                
            }
        }
    }
    func didAuthenticate() {
        UIBlockingProgressHUD.dismiss()
        switchToTabBarController()
    }
        
}

//



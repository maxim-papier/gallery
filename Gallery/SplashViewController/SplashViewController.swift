import UIKit

enum SplashError: String {
    case invalidConfiguration = "Invalid Configuration"
    case failedToPrepSegue = "Failed to prepare to segue for: "
}


final class SplashViewController: UIViewController {
    
    let ShowAuthScreenSegueID = "ShowAuthenticationScreen"
    
    let getTokenService = OAuth2Service()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isTokenAlreadyExist()
    }
    
}


// MARK: - Checking if this is logged in user:

extension SplashViewController {
        
    func isTokenAlreadyExist() {
        
        let tokenStorage = OAuth2TokenStorage()
        
        if tokenStorage.token != nil {
            // logged in
            switchToTabBarController()
        } else {
            // is NOT logged in
            performSegue(withIdentifier: "ShowAuthenticationScreen", sender: nil)
        }
        
    }
    
}


// MARK: - Switch to the TabBarController if user is authorized


extension SplashViewController {
    
    func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else
        { fatalError(SplashError.invalidConfiguration.rawValue) }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
        
    }
    
}

// MARK: -

extension SplashViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowAuthScreenSegueID {
            
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController else {
                fatalError(SplashError.failedToPrepSegue.rawValue + ShowAuthScreenSegueID)
            }
            
            viewController.delegate = self
            
        } else {
            
            super.prepare(for: segue, sender: sender)
            
        }
        
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
 
    func didAuthenticate(_ vc: AuthViewController) {
        switchToTabBarController()
    }
        
}

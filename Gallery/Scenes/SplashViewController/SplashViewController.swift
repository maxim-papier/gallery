import UIKit

enum SplashError: String {
    case invalidConfiguration = "Invalid Configuration"
}


final class SplashViewController: UIViewController, AuthViewControllerDelegate {
        
    private let getTokenService = OAuth2Service()
    private var tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    let tabBarVCID = "TabBarViewControllerID"
    let authViewVCID = "AuthViewControllerID"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupUI()
        switchToAuthOrTabBar()
    }
    
}


// MARK: - UI


extension SplashViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.blackYP
        
        let logoImageYP = UIImage(named: "YPLogo")
        let logoImage = UIImageView(image: logoImageYP)
        
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImage)
        
        logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
}

// MARK: - Checking if this is logged in user:

extension SplashViewController {
    
    func switchToAuthOrTabBar(tokenStorage: OAuth2TokenStorage = OAuth2TokenStorage()) {
            
        if let token = tokenStorage.token {

            print("TOKEN::: \(token)")
            fetchProfile(with: token)

        } else {

            print("NO TOKEN FOUND")
            
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AuthViewControllerID") as! AuthViewController
            
            self.present(controller, animated: true, completion: nil)

            controller.delegate = self
            

        }
        
    }
    
}



// MARK: - Switch to the TabBarController if user is authorized


extension SplashViewController {
    
    func switchToTabBarController() {
        
        guard let window = UIApplication.shared.windows.first else
        { fatalError(SplashError.invalidConfiguration.rawValue) }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: tabBarVCID)
        
        window.rootViewController = tabBarController
        
    }
    
}


// MARK: - Fetches

extension SplashViewController {
    
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        
        UIBlockingProgressHUD.show()
        fetchAuthToken(with: code)
        
    }
    
    func fetchAuthToken(with code: String) {
        
        getTokenService.fetchAuthToken(code) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let token):
                    self.tokenStorage.token = token
                    self.fetchProfile(with: token)
                case .failure(let error):
                    self.showErrorAlert(for: error)
                }
                
            }
            
        }
        
    }
    
}


extension SplashViewController {
    
    func fetchProfile(with token: String) {
        
        profileService.fetchProfile(token) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                    
                case.success(_):
                    UIBlockingProgressHUD.dismiss()
                    self.fetchProfileImageURL()
                    self.switchToTabBarController()
                    
                case.failure(let error):
                    self.showErrorAlert(for: error)
                    break
                }
            }
        }
    }
}


extension SplashViewController {
    
    func fetchProfileImageURL() {
        
        let profile = profileService.profile
        guard let username = profile?.username else { return }
        ProfileImageService.shared.fetchProfileImageURL(username: username) { _ in }
    }
}


// MARK: - Alerts

extension SplashViewController {

    func showErrorAlert(for error: Error) {
    
        let message: Error = error
        let alert = AlertService(vc: self)
        alert.showErrorAlert(on: self, error: message)
        
    }
    
}


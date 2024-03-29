import UIKit
import Kingfisher
import WebKit


protocol ProfileViewControllerProtocol: AnyObject {
    
    var presenter: ProfilePresenterProtocol? { get set }
    
    func updateProfile(profile: Profile)
    func updateAvatar(with url: URL)
    func didTapLogout(show alert: AlertService)
}


final class ProfileViewController: UIViewController {
    
    var presenter: ProfilePresenterProtocol?
    
    private var profileImageServiceObserver: NSObjectProtocol?
    private let token = OAuth2TokenStorage().token
    
    let avatar = UIImageView()
    let nameLabel = UILabel()
    let loginNameLabel = UILabel()
    let descriptionLabel = UILabel()
    let logoutButton = UIButton()
    
    var avatarGradient = CAGradientLayer()
    var nameLabelGradient = CAGradientLayer()
    var loginNameGradient = CAGradientLayer()
    var descriptionGradient = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        avatarGradient = AnimatedGradientCreator().getAnimatedLayer(width: 70, height: 70)
        nameLabelGradient = AnimatedGradientCreator().getAnimatedLayer(width: 256, height: 20)
        loginNameGradient = AnimatedGradientCreator().getAnimatedLayer(width: 128, height: 20)
        descriptionGradient = AnimatedGradientCreator().getAnimatedLayer(width: 64, height: 20)
        
        avatar.layer.addSublayer(avatarGradient)
        nameLabel.layer.addSublayer(nameLabelGradient)
        loginNameLabel.layer.addSublayer(loginNameGradient)
        descriptionLabel.layer.addSublayer(descriptionGradient)
        
        addObserverForNotifications()
        presenter?.viewDidLoad()
    }
    
    @objc private func logoutButtonTapped() {
        presenter?.didTapLogout()
    }
    
    func didTapLogout(show alert: AlertService) {
        
        alert.showLogoutAlert(on: self) {
            self.presenter?.didTapYes()
            let startViewController = SplashViewController()
            
            guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Can't find app!")
                return
            }
            window.rootViewController = startViewController
        }
    }
}


// MARK: - Adding an observer

extension ProfileViewController {
    
    private func addObserverForNotifications() {
        
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.DidChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.presenter?.updateAvatar()
            }
        )
        presenter?.updateAvatar()
        presenter?.updateProfile()

    }
}


// MARK: - UI updates section


extension ProfileViewController: ProfileViewControllerProtocol {

    
    func updateProfile(profile: Profile) {
        self.nameLabel.text = profile.name
        self.loginNameLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
        
        self.nameLabelGradient.removeFromSuperlayer()
        self.loginNameGradient.removeFromSuperlayer()
        self.descriptionGradient.removeFromSuperlayer()
    }
    
    func updateAvatar(with url: URL) {

        // For debugging needs
        // let cache = ImageCache.default
        // cache.clearMemoryCache()
        // cache.clearDiskCache()

        DispatchQueue.main.async {
            self.avatar.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.svg")) {
                result in
                switch result {
                case .success:
                    self.avatarGradient.removeFromSuperlayer()
                case .failure(let error):
                    print("\(error) while loading avatar image!")
                }
            }
        }
    }
}

// MARK: - UI

private extension ProfileViewController {
    
    func setupUI() {
        
        // SETUP UI

        view.backgroundColor = UIColor.blackYP
        setAvatar()
        setNameLabel()
        setLoginNameLabel()
        setLoginNameLabel()
        setDescription()
        setLogoutButton()
        setConstraints()
        

        func setAvatar() {
            
            let profileImage = UIImage(named: "UserPic")
            
            avatar.image = profileImage
            avatar.layer.cornerRadius = 35
            avatar.clipsToBounds = true
            avatar.contentMode = .scaleAspectFill
            
            avatar.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(avatar)
        }
        
        
        func setNameLabel() {
            
            nameLabel.text = "Name"
            
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.textColor = UIColor.whiteYP
            
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(nameLabel)
        }
        
    
        func setLoginNameLabel() {
            
            loginNameLabel.text = "@username"
            
            loginNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
            loginNameLabel.textColor = UIColor.grayYP
            
            loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loginNameLabel)
        }
        
        
        func setDescription() {
            
            descriptionLabel.text = "Biography"
            
            descriptionLabel.font = UIFont.systemFont(ofSize: 13)
            descriptionLabel.textColor = UIColor.whiteYP
            
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionLabel)
        }
        
        
        func setLogoutButton() {
            
            let image = UIImage(named: "logout_icon")
            
            logoutButton.setBackgroundImage(image, for: .normal)
            logoutButton.tintColor = UIColor.redYP
            
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(logoutButton)
            
            logoutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        }
        
        
        // Constraints
        
        func setConstraints() {
            
            // Avatar
            avatar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
            avatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
            avatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            // Name
            nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8).isActive = true
            
            // Login
            loginNameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
            
            // Bio/Description
            descriptionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
            
            // Logout Button
            logoutButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8).isActive = true
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
        }
    }
}

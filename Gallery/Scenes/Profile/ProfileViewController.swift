import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    
    let token = OAuth2TokenStorage().token
    
    var avatar = UIImageView()
    var nameLabel = UILabel()
    var loginNameLabel = UILabel()
    var descriptionLabel = UILabel()
    var logoutButton = UIButton()
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateProfile()
        addObserverForNotifications()
        updateAvatar()
    }
    
}


// MARK: - UI setup

extension ProfileViewController {
    
    func setupUI() {
        
        view.backgroundColor = UIColor.blackYP
        
        // Setting up the avatar
        
        let profileImage = UIImage(named: "UserPic")
        
        avatar.image = profileImage
        
        avatar.layer.cornerRadius = 35
        avatar.clipsToBounds = true
        avatar.contentMode = .scaleAspectFill
        
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatar)
        
        avatar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        avatar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        
        // Setting up the nameLabel
        
        nameLabel.text = "Name"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textColor = UIColor.whiteYP
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8).isActive = true
        
        
        
        // Setting up the loginNameLabel
        
        loginNameLabel.text = "@username"
        loginNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
        loginNameLabel.textColor = UIColor.grayYP
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        
        loginNameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        
        
        
        // Setting up the descriptionLabel
        
        descriptionLabel.text = "Biography"
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = UIColor.whiteYP
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        descriptionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        
        
        
        // Setting up the logoutButton
        
        let image = UIImage(named: "logout_icon")
        
        logoutButton.setBackgroundImage(image, for: .normal)
        logoutButton.tintColor = UIColor.redYP
        
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        logoutButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8).isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
        
        
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
                self.updateAvatar()
            }
        )
        
    }
    
}

// MARK: - UI updates section


extension ProfileViewController {
    
    private func updateProfile() {
        
        let profileService = ProfileService.shared
        let profile = profileService.profile
        
        nameLabel.text = profile?.name
        loginNameLabel.text = profile?.loginName
        descriptionLabel.text = profile?.bio
        
    }
    
}


extension ProfileViewController {
    
    func updateAvatar() {
        
        
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
                
        else {
            print("Error creating URL with profileImageURL = \(String(describing: ProfileImageService.shared.avatarURL))")
            return
        }
        
        DispatchQueue.main.async {
            
            let cache = ImageCache.default
            cache.clearMemoryCache()
            cache.clearDiskCache()
            self.avatar.kf.indicatorType = .activity
            self.avatar.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.svg"))
        }
        
    }
    
}

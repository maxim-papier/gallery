import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    

    let token = OAuth2TokenStorage().token
    
    private var profileImageServiceObserver: NSObjectProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        updateProfile()
        addObserverForNotifications()
        updateAvatar()
    }
}


// UI settings

extension ProfileViewController {
    
    private func setUI() {
        
        view.backgroundColor = UIColor.blackYP
        
        let avatar: UIImageView = {
            
            let profileImage = UIImage(named: "UserPic")
            let imageView = UIImageView(image: profileImage)
            imageView.clipsToBounds = true
            imageView.contentMode = .scaleAspectFill
            
            imageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageView)
            
            imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
            
            return imageView
            
        }()
        
        let nameLabel: UILabel = {
            
            let nameLabel = UILabel()
            
            nameLabel.text = "Name"
            nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
            nameLabel.textColor = UIColor.whiteYP
            
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(nameLabel)
            
            nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 8).isActive = true
            
            return nameLabel
            
        }()
        
        
        let loginNameLabel: UILabel = {
            
            let loginNameLabel = UILabel()
            
            loginNameLabel.text = "@username"
            loginNameLabel.font = UIFont.boldSystemFont(ofSize: 13)
            loginNameLabel.textColor = UIColor.grayYP
            
            loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(loginNameLabel)
            
            loginNameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
            
            return loginNameLabel
            
        }()
        
        
        let descriptionLabel: UILabel = {
            
            let descriptionLabel = UILabel()
            
            descriptionLabel.text = "Biography"
            descriptionLabel.font = UIFont.systemFont(ofSize: 13)
            descriptionLabel.textColor = UIColor.whiteYP
            
            descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(descriptionLabel)
            
            descriptionLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
            
            return descriptionLabel
            
        }()
        
        
        let logoutButton: UIButton = {
            
            let image = UIImage(named: "logout_icon")
            let logoutButton = UIButton()
            logoutButton.setBackgroundImage(image, for: .normal)
            
            logoutButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(logoutButton)
            
            logoutButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -8).isActive = true
            logoutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 55).isActive = true
            
            return logoutButton
            
        }()
        
    }
}


// Adding an observer

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

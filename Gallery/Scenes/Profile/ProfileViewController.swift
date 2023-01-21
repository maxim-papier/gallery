import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var avatar: UIImageView!
    
    let token = OAuth2TokenStorage().token
    
    private var profileImageServiceObserver: NSObjectProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfile()
        addObserverForNotifications()
        updateAvatar()
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
            
            self.avatar.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.svg"))
        }
        
       

        
    }
    
}

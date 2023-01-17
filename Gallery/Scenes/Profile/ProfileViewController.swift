import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    let token = OAuth2TokenStorage().token
    
    private var profileImageServiceObserver: NSObjectProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfile()
        addObserverForNotifications()
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
        
        nameLabel.text = profile?.username
        loginNameLabel.text = profile?.loginName
        descriptionLabel.text = profile?.bio
        
    }
    
}


extension ProfileViewController {
    
    func updateAvatar() {
     
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        #warning("KINGFISHER")
        
    }
    
}

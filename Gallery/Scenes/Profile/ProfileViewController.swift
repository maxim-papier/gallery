import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    let profileService = ProfileService()
    let token = OAuth2TokenStorage().token
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateProfile()
    }
}

extension ProfileViewController {
    
    private func updateProfile() {
        
        let profileService = ProfileService.shared
        let profile = profileService.profile
        
        nameLabel.text = profile?.username
        loginNameLabel.text = profile?.loginName
        descriptionLabel.text = profile?.bio
        
    }
    
}



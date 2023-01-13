import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    let prof = ProfileService()
    let token = OAuth2TokenStorage().token
    
    override func viewDidLoad() {
        super.viewDidLoad()

        prof.fetchProfile(token!) { [weak self] result in
            guard let self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                case.success(let result):
                    self.nameLabel.text = result.name
                    self.loginNameLabel.text = result.loginName
                    self.descriptionLabel.text = result.bio
                case.failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
    }
}



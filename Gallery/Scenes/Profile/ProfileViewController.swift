import UIKit

class ProfileViewController: UIViewController {
    
    let prof = ProfileService()
    let token = OAuth2TokenStorage().token
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prof.fetchProfile(token!) { result in
            
            switch result {
            case.success(let profileResult):
                print(profileResult.loginName)
            case.failure(let error):
                print("ERROR: \(error.localizedDescription)")
                
            }
        }
    }
}


import UIKit

class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    
    let logoutHelper: LogoutHelperProtocol
    init(logoutHelper: LogoutHelperProtocol, view: ProfileViewController) {
        self.logoutHelper = logoutHelper
        self.view = view
    }

    var viewDidLoadCalled = false
    var updateProfileCalled = false
    var updateAvatarCalled = false
    
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func updateProfile() {
        updateProfileCalled = true
    }
    
    func updateAvatar() {
        updateAvatarCalled = true
    }
    
    func didTapLogout() {
        
    }
    
    func didTapYes() {
        
    }
    
    
    
    
    
}

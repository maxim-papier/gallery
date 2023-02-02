import Foundation

class ProfilePresenterSpy: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    
    var viewDidLoadCalled = false
    var updateProfileCalled = false
    var updateAvatarCalled = false
    
    func viewDidLoad() {}
    func updateProfile() {}
    func updateAvatar() {}
    func didTapLogout() {}
    func didTapYes() {}
}

import Foundation

final class ProfileVCSpy: ProfileViewControllerProtocol {
    
    var presenter: ProfilePresenterProtocol?
    
    var updateAvatarDidCalled = false
    var gotAlertToShow = false

    
    func updateProfile(profile: Profile) {
        
    }
    
    func updateAvatar(with url: URL) {
        updateAvatarDidCalled = true
    }
    
    func didTapLogout(show alert: AlertService) {
        gotAlertToShow = true
    }
    
}

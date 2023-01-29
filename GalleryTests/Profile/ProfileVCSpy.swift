import Foundation

final class ProfileVCSpy: ProfileViewControllerProtocol {
    
    var presenter: Gallery.ProfilePresenterProtocol?

    func updateProfile(profile: Profile) {}
    func updateAvatar(with url: URL) {}
    
    func didTapLogout(show alert: AlertService) {
        presenter?.didTapYes()
    }
}

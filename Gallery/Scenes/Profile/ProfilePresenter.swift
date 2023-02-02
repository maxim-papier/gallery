import Foundation
import UIKit

protocol ProfilePresenterProtocol: AnyObject {
    
    var view: ProfileViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func updateProfile()
    func updateAvatar()
    func didTapLogout()
    func didTapYes()
}

final class ProfilePresenter: ProfilePresenterProtocol {
    
    weak var view: ProfileViewControllerProtocol?
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    var logoutHelper: LogoutHelperProtocol
    
    init(view: ProfileViewControllerProtocol?, logoutHelper: LogoutHelperProtocol) {
        self.view = view
        self.logoutHelper = logoutHelper
    }

    func viewDidLoad() {
        updateProfile()
        updateAvatar()
    }

    
    func updateProfile() {
        
        guard let profile = profileService.profile else {
            print("Error: profile not found.")
            return
        }
        view?.updateProfile(profile: profile)
    }
    
    func updateAvatar() {
        
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
                
        else {
            print("Error creating URL with profileImageURL = \(String(describing: ProfileImageService.shared.avatarURL))")
            return
        }
    
        view?.updateAvatar(with: url)
    }
    
    func didTapLogout() {
        let alert = logoutHelper.showLogoutAlert()
        view?.didTapLogout(show: alert)
    }
    
    func didTapYes() {
        logoutHelper.didLogout()
    }
}

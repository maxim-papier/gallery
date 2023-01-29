import UIKit

protocol LogoutHelperProtocol {
    func showLogoutAlert() -> AlertService
    func didLogout()
}

final class LogoutHelper: LogoutHelperProtocol {
    
    
    func showLogoutAlert() -> AlertService {
        let alert = AlertService()
        return alert
    }
    
    func didLogout() {
        var tokenStorage = OAuth2TokenStorage()
        CookieCleanerService.clean()
        tokenStorage.token = nil
    }
}





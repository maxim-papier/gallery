import Foundation

struct OAuth2TokenStorage {
    
    private let tokenKey = "BearerToken"
    
    var token: String? {
        
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
        
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        
    }
    
    
}

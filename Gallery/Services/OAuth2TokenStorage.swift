import Foundation
import SwiftKeychainWrapper


enum TokenStorageError: Error {
    case tokenNotFound
    case newValueError
}


struct OAuth2TokenStorage {
    
    private let tokenKey = "BearerToken"
    let removeSuccessful: Bool = KeychainWrapper.standard.removeObject(forKey: "BearerToken")
    

    var token: String? {
        
        set {
            
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                return
            }
            
        }
        get { return KeychainWrapper.standard.string(forKey: tokenKey) }
        
    }
    
    func updateToken(with newValue: String?) {
        
        if let newValue = newValue {
            
            KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            
        } else {
            return
        }
    }
    
    
}

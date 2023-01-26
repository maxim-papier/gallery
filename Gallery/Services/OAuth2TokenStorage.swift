import Foundation
import SwiftKeychainWrapper
import WebKit


enum TokenStorageError: String, Error {
    case tokenNotFound
    case newValueError
}


struct OAuth2TokenStorage {
    
    private let tokenKey = "BearerToken"

    var token: String? {
        
        set {
            
            if let newValue = newValue {
                KeychainWrapper.standard.set(newValue, forKey: tokenKey)
            } else {
                KeychainWrapper.standard.removeObject(forKey: tokenKey)
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
    
    static func clean() {
       // Очищаем все куки из хранилища.
       HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
       // Запрашиваем все данные из локального хранилища.
       WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
          // Массив полученных записей удаляем из хранилища.
          records.forEach { record in
             WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
          }
       }
    }

    
    
}

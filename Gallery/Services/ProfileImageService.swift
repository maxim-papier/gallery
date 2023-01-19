import Foundation

final class ProfileImageService {
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    private(set) var avatarURL: String?
    
    static let shared = ProfileImageService() // Singleton
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange") // Notification name

    private let tokenStorage = OAuth2TokenStorage()
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        let request = URLRequest.makeHTTPRequest(
            path: "/user/\(username)",
            httpMethod: "GET",
            baseURL: K.defaultBaseAPIURL
        )
        
        guard tokenStorage.token != nil else {
            completion(.failure(TokenStorageError.tokenNotFound))
            return
        }
        
        task = session.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            
            switch result {
            
            case .success(let profileImageResult):
                
                guard let avatarURL = profileImageResult.profileImage.small else {
                    completion(.failure(FetchProfileImageError.noImageDataFound))
                    return
                }
                self.avatarURL = avatarURL
                completion(.success(avatarURL))
                
                NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": avatarURL])
            
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

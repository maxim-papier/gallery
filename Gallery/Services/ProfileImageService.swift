import Foundation

final class ProfileImageService {
    
    static let shared = ProfileImageService() // Singleton
    static let DidChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange") // Notification name
    
    private(set) var avatarURL: String?
    
    let urlSession = URLSession.shared
    var task: URLSessionTask?
    let token = OAuth2TokenStorage().token
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        var request = URLRequest.makeHTTPRequest(
            path: "/user/\(username)",
            httpMethod: "GET",
            baseURL: K.defaultBaseAPIURL
        )
        
        guard let token = token else {
            completion(.failure(TokenStorageError.tokenNotFound))
            return
        }
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self.handleResponse(response, data: data, completion: completion)
            }
        }
        task.resume()
        
    }
    
    
    private func handleResponse(_ response: URLResponse?, data: Data?, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            DispatchQueue.main.async {
                completion(.failure(FetchProfileImageError.invalidResponse))
                return
            }
            return
        }
        handleData(data, completion: completion)
        
    }
    
    
    private func handleData(_ data: Data?, completion: @escaping (Result<String, Error>) -> Void) {
        
        if let data {
            decodeData(data, completion: completion)
        } else {
            completion(.failure(FetchProfileImageError.dataError))
            return
        }
        
    }
    
    
    private func decodeData(_ data: Data, completion: @escaping (Result<String, Error>) -> Void) {
        
        let decoder = JSONDecoder()
        
        guard let profileImageResult = try? decoder.decode(UserResult.self, from: data) else {
            completion(.failure(FetchProfileImageError.decodingData))
            return
        }
        
        guard let avatarURL = profileImageResult.profileImage.small else {
            completion(.failure(FetchProfileImageError.noImageDataFound))
            return
        }
        
        completion(.success(avatarURL))
        NotificationCenter.default.post(name: ProfileImageService.DidChangeNotification, object: self, userInfo: ["URL": avatarURL]) // Publish notification
        
    }
    
}

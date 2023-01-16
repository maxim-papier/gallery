import Foundation


enum FetchProfileImageError: Error {
    case invalidResponse
    case dataError
    case noImageData
    case decodingData
}


final class ProfileImageService {
    
    let urlSession = URLSession.shared
    var task: URLSessionTask?
    let token = OAuth2TokenStorage().token
    
    private(set) var avatarURL: String?
    static let shared = ProfileImageService()
    
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        
        var request = URLRequest.makeHTTPRequest(path: "/users/\(username)", httpMethod: "GET")
        
        if let token {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print(TokenStorageError.tokenNotFound)
            return
        }
        
        print("REQUEST: \(request)")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            print("DATA:::: \(data)")
            self.handleResponse(response, data: data, completion: completion)
            
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
        
        print("DATA: \(data)")
        print("AVATAR:::: \(avatarURL)")
        
        do {
            let profileImageResult = try decoder.decode(UserResult.self, from: data)
            print("PROFILE IMAGE RESULT \(profileImageResult)")
            let result = profileImageResult.profileImage
            let image = result.small
            avatarURL = image
            
            guard let avatarURL else {
                completion(.failure(FetchProfileImageError.noImageData))
                return
            }
            completion(.success(avatarURL))
        } catch {
            completion(.failure(error))
            return
        }
        
    }
    
}


    


extension URLRequest {
    
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: URL = K.defaultBaseURL!) -> URLRequest {
        
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        
        return request
    }
    
}

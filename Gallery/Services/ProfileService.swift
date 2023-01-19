import Foundation

final class ProfileService {
    
    static let shared = ProfileService() // Singleton
    
    private(set) var profile: Profile?
    
    let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    /// Fetch profile from the API
    /// - Parameters:
    ///   - token: The authentication token to be used in the request
    ///   - completion: A callback that will be called with the result of the API request
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        task?.cancel()
        
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: K.defaultBaseAPIURL
        )
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            self.handleResponse(response, data: data, completion: completion)
            
        }
        task.resume()
    }
    
    /// Handle the API response and check for errors
    /// - Parameters:
    ///   - response: The API response
    ///   - data: The data received in the response
    ///   - completion: A callback that will be called with the result of the API request
    
    private func handleResponse(_ response: URLResponse?, data: Data?, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            DispatchQueue.main.async {
                completion(.failure(FetchProfileError.invalidResponse))
                return
            }
            return
        }
        handleData(data, completion: completion)
        
    }
    
    /// Handle the received data from the API and decode it
    /// - Parameters:
    ///   - data: The data received from the API
    ///   - completion: A callback that will be called with the result of decoding the data
    
    private func handleData(_ data: Data?, completion: @escaping (Result<Profile, Error>) -> Void) {
        if let data {
            decodeData(data, completion: completion)
        } else {
            completion(.failure(FetchProfileError.dataError))
            return
        }
    }
    
    /// Decode the received data from the API
    /// - Parameters:
    ///   - data: The data to be decoded
    ///   - completion: A callback that will be called with the result of decoding the data
    
    private func decodeData(_ data: Data, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        let decoder = JSONDecoder()
        
        do {
            let profileResult = try decoder.decode(ProfileResult.self, from: data)
            profile = Profile(result: profileResult)
            
            guard let profile else {
                completion(.failure(FetchProfileError.noProfileData))
                return
            }
            completion(.success(profile))
        } catch {
            completion(.failure(FetchProfileError.decodingData))
            return
        }
        
    }
    
}

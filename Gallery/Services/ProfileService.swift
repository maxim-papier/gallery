import Foundation

enum FetchProfileError: String, Error {
    case noProfileData
}


final class ProfileService {
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    private var lastCode: String?
    
    static let shared = ProfileService() // Singleton
    private(set) var profile: Profile?
    
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        assert(Thread.isMainThread)

        if let currentTask = task {
            currentTask.cancel()
        }
        
        
        var request = URLRequest.makeHTTPRequest(
            path: "/me",
            httpMethod: "GET",
            baseURL: K.defaultBaseAPIURL
        )
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            
            switch result {
                
            case .success(let profileResult):
                self.profile = Profile(result: profileResult)
                guard let profile = self.profile else {
                    completion(.failure(FetchProfileError.noProfileData))
                    return
                }
                completion(.success(profile))
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
}

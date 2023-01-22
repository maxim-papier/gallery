import Foundation

enum FetchTokenError: Error {
    case serializationError(Error)
}

final class OAuth2Service {
    
    private let session = URLSession.shared
    private var task: URLSessionTask?
    
    private var lastCode: String?

    private (set) var authToken: String? {
        get {
            return OAuth2TokenStorage().token
        }
        set {
            guard let newValue = newValue else {
                
            return }
            OAuth2TokenStorage().updateToken(with: newValue)
        }
    }

    
    // Attempts to get the token from the server by passing "code" as the parameter

    func fetchAuthToken(
        _ code: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        
        assert(Thread.isMainThread)
        
        guard lastCode != code else { return }
        task?.cancel()
        lastCode = code
        
        
        let request = authTokenRequest(with: code)
        
        task = session.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            guard let self else { return }
        
            switch result {
                
            case .success(let body):
                let receivedAuthToken = body.accessToken
                self.authToken = receivedAuthToken
                completion(.success(receivedAuthToken))
                
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
}


extension OAuth2Service {
    
    private func authTokenRequest(with code: String) -> URLRequest {
        
        var request = URLRequest.makeHTTPRequest(
            path: K.tokenURLPath,
            httpMethod: "POST",
            baseURL: K.defaultBaseURL)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "client_id": K.accessKey,
            "client_secret": K.secretKey,
            "redirect_uri": K.redirectUri,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        return request
    }
    
}




import Foundation

enum FetchError: Error {
    case noResponse
    case invalidResponse
    case decodingError
}

class OAuth2Service {
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        // MARK: - Settings
        
        var urlRequest = URLRequest(url: URL(string: K.getTokenURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        print("PRINTING: \(urlRequest)")
        
        let parameters: [String: Any] = [
            "client_id": K.accessKey,
            "client_secret": K.secretKey,
            "redirect_uri": K.redirectUri,
            "code": code,
            "grant_type": "authorization_code"
        ]
        
        do  {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("JSON serialization error \(error)")
        }
        
        // MARK: - Send request to the server
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(FetchError.invalidResponse))
                    print("RESPONSE: \(String(describing: response))")
                }
                return
            }
            
            // Check data
            if let data {
                
                do {
                    let tokenResponse = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                                        
                    DispatchQueue.main.async {
                        let token = tokenResponse.accessToken
                        completion(.success(token))
                        print("TOKEN \(token)")
                    }
                    
                } catch {
                    completion(.failure(FetchError.decodingError))
                }
            }
        }.resume()
    }
}

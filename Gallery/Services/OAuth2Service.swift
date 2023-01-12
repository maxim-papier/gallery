import Foundation

enum FetchError: Error {
    case noResponse
    case invalidResponse
    case decodingError
}

class OAuth2Service {
    
    
    // Attempts to get the token from the server by passing "code" as the parameter
    
    func fetchAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        do {
            let urlRequest = try buildURLRequest(code: code)
            sendRequest(urlRequest: urlRequest, completion: completion)
        } catch {
            completion(.failure(error))
        }

    }
    
    
    // MARK: - Build URL request
    
    private func buildURLRequest(code: String) throws -> URLRequest {
                
        var urlRequest = URLRequest(url: URL(string: K.getTokenURL)!)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
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
        
        return urlRequest
        
    }
    
    // MARK: - Send request to the server
    
    private func sendRequest(urlRequest: URLRequest, completion: @escaping (Result<String, Error>) -> Void ) {
                
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
                    }
                    
                } catch {
                    completion(.failure(FetchError.decodingError))
                }
            }
        }.resume()

        
    }
    
}

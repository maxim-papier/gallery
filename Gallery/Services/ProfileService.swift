import Foundation

enum FetchProfileError: Error {
    case dataError
    case decodingData
    case invalidResponse
}

final class ProfileService {
    
    let urlSession = URLSession.shared
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        
        let url = K.defaultBaseURL!.appendingPathComponent("/me")
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        urlSession.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                DispatchQueue.main.async {
                    completion(.failure(FetchProfileError.invalidResponse))
                }
                return
            }
            
            // Check data
            if let data = data {
                
                let decoder = JSONDecoder()
                do {
                    let profileResult = try decoder.decode(ProfileResult.self, from: data)
                    let profile = Profile(result: profileResult)
                } catch {
                    print("Decoding failed: \(error)")
                }
            

                
                
            } else {
                completion(.failure(FetchProfileError.dataError))
            }
        }.resume()
        
    }
    
}


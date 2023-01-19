import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case decodingError
    case dataError
}


// MARK: - Prepare for request

extension URLRequest {
    
    static func makeHTTPRequest(
        path: String,
        httpMethod: String,
        baseURL: URL!
    ) -> URLRequest {
        
        var request = URLRequest(url: URL(string: path, relativeTo: baseURL)!)
        request.httpMethod = httpMethod
        
        return request
        
    }
}


// MARK: - Request


extension URLSession {
    
    func objectTask<T: Decodable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        
        let completionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request) { data, response, error in
            if let error {
                completionOnMainThread(.failure(NetworkError.urlRequestError(error)))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionOnMainThread(.failure(NetworkError.urlSessionError))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completionOnMainThread(.failure(NetworkError.httpStatusCode(response.statusCode)))
                return
            }
            
            guard let data else {
                completionOnMainThread(.failure(NetworkError.dataError))
                return
            }
            
            do {
                let result = try JSONDecoder().decode(T.self, from: data)
                completionOnMainThread(.success(result))
            } catch {
                completionOnMainThread(.failure(NetworkError.decodingError))
            }
        }
        
        task.resume()
        return task
        
    }
}

import Foundation

enum FetchPhotoError: String, Error {
    case noPhotoData
    case photoNotExists
}


final class ImageListService {
    
    private var task: URLSessionTask?
    private let session = URLSession.shared
    
    
    private let notificationCenter: NotificationCenter = .default
    let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    
    private let tokenStorage = OAuth2TokenStorage()
    private (set) var photos: [Photo] = [] {
        didSet { notificationCenter.post(name: didChangeNotification, object: self) }
    }
    
    private var lastLoadedPage: Int?
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return formatter
    }()
    
    func prepareForDisplay(index: Int) {
        guard index == photos.count - 1, task == nil else {
            return
        }
        fetchPhotosNextPage()
    }
    
    
    
    // MARK: - Service
    
    func fetchPhotosNextPage() {
        
        let token = tokenStorage.token
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        guard let token = token else {
            print(TokenStorageError.tokenNotFound)
            return
        }
        
        
        let request = photoRequest(with: token, page: nextPage)
        
        task = session.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            
            switch result {
                
            case let .success(photoResults):
                let photos = photoResults.map {
                    $0.convertToViewModel(formatter: self.dateFormatter)
                }
                print("Task succeeded")
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.photos += photos
                    self.lastLoadedPage = nextPage + 1
                }
                
            case let .failure(error):
                print("Task error: \(error.localizedDescription)")
            }
            self.task = nil
        }
    }
}


private extension ImageListService {
    
    func photoRequest(with token: String, page: Int) -> URLRequest {
        
        var request = URLRequest.makeHTTPRequest(
            path: K.photosURLPath,
            httpMethod: "GET",
            baseURL: K.defaultBaseAPIURL
        )
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        var components = URLComponents(url: request.url!, resolvingAgainstBaseURL: false)!
        components.queryItems = [
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: "10"),
            URLQueryItem(name: "order_by", value: "popular")
        ]
        request.url = components.url
        print("REQUEST: \(request)")
        return request
    }
}



extension ImageListService {
    
    func changeLike(for photoID: String, with isLiked: Bool, _ completion: @escaping (Error?) -> Void) {
        
        let token = OAuth2TokenStorage().token
        
        guard let token = token else {
            print(TokenStorageError.tokenNotFound)
            return
        }
        
        var request = URLRequest.makeHTTPRequest(
            path: K.photosURLPath + "/\(photoID)/likes",
            httpMethod: isLiked ? "POST" : "DELETE",
            baseURL: K.defaultBaseAPIURL
        )
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        guard var photo = self.photos.first(where: { $0.id == photoID } ) else {
            completion(FetchPhotoError.photoNotExists)
            return
        }
        
        photo.isLiked = isLiked
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                return
            } else {
                completion(NetworkError.urlSessionError)
            }
        }
        task.resume()
    }
}


private extension PhotoResult {
    func convertToViewModel(formatter: DateFormatter) -> Photo {
        Photo(
            id: self.id,
            description: self.description,
            thumbnailImage: self.urls.small,
            largeImage: self.urls.full,
            size: .init(
                width: self.width,
                height: self.height
            ),
            createdAt: formatter.date(from: self.createdAt) ?? Date(),
            isLiked: self.likedByUser
        )
    }
}



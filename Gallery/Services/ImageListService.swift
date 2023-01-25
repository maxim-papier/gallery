import Foundation

enum FetchPhotoError: String, Error {
    case noPhotoData
}



final class ImageListService {
    
    private var task: URLSessionTask?
    private let session = URLSession.shared
    
    
    private let notificationCenter: NotificationCenter = NotificationCenter()
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
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.photos += photos
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
            self.task = nil
        }
    }
}


private extension ImageListService {
    
        func photoRequest(with token: String, page: Int) -> URLRequest {
        
        var request = URLRequest.makeHTTPRequest(
            path: K.tokenURLPath,
            httpMethod: "GET",
            baseURL: K.defaultBaseAPIURL
        )
        
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let parameters: [String: Any] = [
            "page": page,
            "per_page": 10,
            "order_by": "popular"
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        return request
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

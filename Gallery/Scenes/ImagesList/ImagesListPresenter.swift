import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var photosCount: Int { get }
    var service: ImageListServiceProtocol { get }
    func load()
    func readyForDisplay(index: Int)
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func photo(index: Int) -> Photo
    func updateTableViewAnimated(tableView: UITableView)
}


final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    var service: ImageListServiceProtocol
    private var dateFormatter: DateFormatter
    
    init(service: ImageListServiceProtocol) {
        self.service = service
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .long
        self.dateFormatter.timeStyle = .none
    }
    
    var photosCount: Int { service.photos.count }
    
    
    func load() {
        service.fetchPhotosNextPage()
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let photo = service.photos[indexPath.row]
        let photoURL = photo.thumbnailImage
        
        cell.previewImage.kf.indicatorType = .activity
        cell.previewImage.kf.setImage(with: photoURL, placeholder: UIImage(named: "stub"))
        
        let isLiked = photo.isLiked
        cell.setLike(isLiked)
        
        let date = dateFormatter.string(from: photo.createdAt)
        cell.dateLabel.text = date
        
    }
    
    func photo(index: Int) -> Photo {
        service.photos[index]
    }
        
    func readyForDisplay(index: Int) {
        service.prepareForDisplay(index: index)
    }
    
    func updateTableViewAnimated(tableView: UITableView) {
        
        let oldCount = tableView.numberOfRows(inSection: 0)
        let newCount = service.photos.count
        
        if oldCount < newCount {
            
            let newIndexPath = (oldCount..<newCount).map { IndexPath(row: $0, section: 0)
            }
                        
            tableView.performBatchUpdates {
                tableView.insertRows(at: newIndexPath, with: .automatic)
            }
        }
    }
    
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        
        UIBlockingProgressHUD.show()
        
        let photo = service.photos[indexPath.row]
        let photoID = photo.id
        let isLiked = photo.isLiked
        
        service.changeLike(for: photoID, with: !isLiked) { error in
            
            DispatchQueue.main.async {
                
                UIBlockingProgressHUD.dismiss()
                
                if let error = error {
                    assertionFailure("Like engine is broken :) \(error)")
                } else {
                    let image = isLiked ? UIImage(named: "likeButton_isNotActive") : UIImage(named: "likeButton_isActive")
                    cell.likeButton.setImage(image, for: .normal)
                }
            }
        }
    }
}

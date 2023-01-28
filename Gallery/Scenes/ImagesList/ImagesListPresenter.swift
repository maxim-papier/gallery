import UIKit
import Kingfisher

protocol ImagesListPresenterProtocol: AnyObject {
    
    func fetchPhotosNextPage()
    func readyForDisplay(index: Int)
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func didLoad()
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    
    var photosCount: Int { get }
    func photo(index: Int) -> Photo
    
    func updateTableViewAnimated(tableView: UITableView)
    
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    
    var service: ImageListService
    
    init(service: ImageListService) {
        self.service = service
    }
    
    var photosCount: Int {
        let count = service.photos.count
        print("CUNT \(count)")
        return count
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    func didLoad() {
        service.fetchPhotosNextPage()
    }
    
    
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        let photo = service.photos[indexPath.row]
        let photoURL = photo.thumbnailImage
        
        print("PHOTO ID: \(photo.id)")
        
        cell.previewImage.kf.indicatorType = .activity
        cell.previewImage.kf.setImage(with: photoURL, placeholder: UIImage(named: "stub"))
        
        let isLiked = photo.isLiked
        cell.setLike(isLiked)
        
        let date = dateFormatter.string(from: photo.createdAt)
        cell.dateLabel.text = date
        
    }
    
    func photo(index: Int) -> Photo {
        return service.photos[index]
    }
    
    func fetchPhotosNextPage() {
        service.fetchPhotosNextPage()
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
            
            print("performBatchUpdates!!!")
            
            tableView.performBatchUpdates {
                tableView.insertRows(at: newIndexPath, with: .automatic)
            }
        }
    }
    
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        
        let photo = service.photos[indexPath.row]
        let photoID = photo.id
        let isLiked = photo.isLiked

        service.changeLike(for: photoID, with: !isLiked) { error in

            UIBlockingProgressHUD.dismiss()

            if let error {
                assertionFailure("Like engine is broken :) \(error)")
                return
                
            } else {

                let image = !isLiked ? UIImage(named: "likeButton_isActive") : UIImage(named: "likeButton_isNotActive")

                DispatchQueue.main.async {
                    cell.likeButton.setImage(image, for: .normal)
                }
            }
        }
        
    }
    
}

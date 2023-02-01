import UIKit

protocol ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    
    var service: ImageListService { get }
    func load()
    func readyForDisplay(index: Int)
    func cellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath)
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func photo(index: Int) -> Photo
    func updateTableViewAnimated(tableView: UITableView)
}


final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    
    var service: ImageListService
    private var dateFormatter: DateFormatter
    
    init(service: ImageListService) {
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
        
        //cell.previewImage.image = UIImage(named: "stub")
        
        let thumbnailGradient = AnimatedGradientCreator().getAnimatedLayer(
            width: cell.previewImage.bounds.width,
            height: cell.previewImage.bounds.height,
            radius: 16
        )
        
        cell.previewImage.layer.addSublayer(thumbnailGradient)
        cell.previewImage.layer.zPosition = 1

        
        // cell.previewImage.kf.indicatorType = .activity
        cell.previewImage.kf.setImage(with: photoURL, placeholder: UIImage(named: "stub")) { _ in
            cell.previewImage.contentMode = .scaleAspectFill
            thumbnailGradient.removeFromSuperlayer()
            cell.previewImage.layer.zPosition = 0
        }
        
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
    
    
    func cellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        
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

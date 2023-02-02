import UIKit

protocol ImagesListPresenterProtocol {
    
    var view: ImagesListViewControllerProtocol? { get set }
    var photosCount: Int { get }
    
    var service: ImageListService { get }
    func load()
    func readyForDisplay(index: Int)
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func cellDidTapLike(at indexPath: IndexPath)
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
        let isLiked = photo.isLiked
        let date = dateFormatter.string(from: photo.createdAt)
        
        cell.setLike(isLiked)
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
            let newIndexPath = (oldCount..<newCount).map {
                IndexPath(row: $0, section: 0)
            }
            tableView.performBatchUpdates {
                tableView.insertRows(
                    at: newIndexPath,
                    with: .automatic
                )
            }
        }
    }
    
    func cellDidTapLike(at indexPath: IndexPath) {
        
        let photo = service.photos[indexPath.row]
        let photoID = photo.id
        let isLiked = photo.isLiked
        
        service.changeLike(
            for: photoID,
            with: !isLiked) { [weak self] error in
                self?.cellDidLike(error: error, indexPath: indexPath, isLiked: isLiked)
            }
    }
    
    func cellDidLike(error: Error?, indexPath: IndexPath, isLiked: Bool) {
        view?.cellDidLike(error: error, indexPath: indexPath, isLiked: !isLiked)
    }
    
}

import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var loadDidCalled = false
    
    var view: ImagesListViewControllerProtocol?
    
    var photosCount: Int = 0
        
    
    func load() {
        loadDidCalled = true
        service.fetchPhotosNextPage()
    }
    
    func readyForDisplay(index: Int) {
        service.prepareForDisplay(index: index)
    }
    
    func cellDidTapLike(_ cell: ImagesListCell, indexPath: IndexPath) {
        
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
    }
    
    func photo(index: Int) -> Photo {
        return service.photos[index]
    }
    
    func updateTableViewAnimated(tableView: UITableView) {
        
    }
    
    var service = ImageListService()
    
    
    
}

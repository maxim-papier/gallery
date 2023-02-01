import UIKit

final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    
    var loadDidCalled = false
    var view: ImagesListViewControllerProtocol?
    var photosCount: Int = 0
    var service = ImageListService()
    
    func load() {
        loadDidCalled = true
        service.fetchPhotosNextPage()
    }
    
    func readyForDisplay(index: Int) { service.prepareForDisplay(index: index) }
    func photo(index: Int) -> Photo { return service.photos[index] }
    
    func cellDidTapLike(at indexPath: IndexPath) {}
    func updateTableViewAnimated(tableView: UITableView) {}
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {}
}

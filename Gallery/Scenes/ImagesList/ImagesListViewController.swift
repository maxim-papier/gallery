import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    
    @IBOutlet private var tableView: UITableView!
    
    private let ShowSingleImageSegueID = "ImagesListToSingleImage"
    private let notificationCenter: NotificationCenter = .default
    private let imagesListService: ImageListService = ImageListService()
    private var imagesListObserver: NSObjectProtocol?
    
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imagesListService.fetchPhotosNextPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        observeImagesListChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingImagesListChanges()
    }
}

// When user tap on the cell

#warning("Отправить задание на переход, если кликнули по ячейке")
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueID, sender: indexPath)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            segue.identifier == ShowSingleImageSegueID,
            let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath
        else {
            assertionFailure("Not expected")
            return
        }
        
        let url = imagesListService.photos[indexPath.row].largeImage
        viewController.image = url
    }
    
}


// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
#warning("REF: Настройка кол-ва строк в секции")
        let count = imagesListService.photos.count
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
#warning("REF 1: Получение ячейки из пула переиспользуемых")
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier , for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            fatalError("ImageList cell error")
        }
        
#warning("REF 2: Задание на показ картинок в ImageListCell")
        let photo = imagesListService.photos[indexPath.row]
        let url = photo.thumbnailImage
        
        imagesListCell.previewImage.kf.indicatorType = .activity
        imagesListCell.previewImage.kf.setImage(with: url, placeholder: UIImage(named: "stub"))
        
#warning("REF 2.1: Форматирование даты для вывода на ImageListCell")
        let date = dateFormatter.string(from: photo.createdAt)
        imagesListCell.dateLabel.text = date
        
#warning("REF 2.2: Задание для ImageListCell отобразить или нет лайк ❤️")
        imagesListCell.setLike(photo.isLiked)
        imagesListCell.delegate = self
        
        return imagesListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
#warning("REF 3: Задание для ImageService на подгрузку следующих 10 картинок, если до них дошла очередь")
        imagesListService.prepareForDisplay(index: indexPath.row)
    }
    
}


// MARK: - ImagesListCellDelegate


extension ImagesListViewController: imagesListCellDelegate {
    
#warning("REF 4: реагирует на лайк пользователя по сердечку в ячейке")
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell),
              indexPath.row < imagesListService.photos.count else {
            return
        }
#warning("REF 4.1: Блокирует интерфейс")
        UIBlockingProgressHUD.show()
        
#warning("REF 4.2: определяет какая фотка должна быть лайк/анлайк")
        let photo = imagesListService.photos[indexPath.row]
        let photoID = photo.id
        let isLiked = photo.isLiked
        
#warning("REF 4.3: Вызывает метод changeLike у ImageService")
        imagesListService.changeLike(for: photoID, with: !isLiked) { error in
            
            UIBlockingProgressHUD.dismiss()
            
#warning("REF 4.4 Получив ответ разблокирует экран")
            if let error {
                assertionFailure("Like engine is broken :) \(error)")
                return
            } else {
                
#warning("REF 4.5 отправляет задание на смену картинки в ячейке")
                let image = !isLiked ? UIImage(named: "likeButton_isActive") : UIImage(named: "likeButton_isNotActive")
                
                DispatchQueue.main.async {
                    cell.likeButton.setImage(image, for: .normal)
                }
            }
        }
    }
}


// MARK: - Observe ImagesList Changes

extension ImagesListViewController {
#warning("REF5: Добавляет/отключает обсервер")
    private func observeImagesListChanges() {
        imagesListObserver = notificationCenter.addObserver(
            forName: imagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
    
    
    private func stopObservingImagesListChanges() {
        if let imagesListObserver {
            notificationCenter.removeObserver(imagesListObserver)
        }
    }
    
#warning("REF 5.1: Если приходит нотификация о добавлении новых десяти фото, то добавляет строки в таблицу")
    private func updateTableViewAnimated() {
        
        let oldCount = tableView.numberOfRows(inSection: 0)
        let newCount = imagesListService.photos.count
        
        if oldCount < newCount {
            
            let newIndexPath = (oldCount..<newCount).map { IndexPath(row: $0, section: 0)
            }
            
            print("performBatchUpdates!!!")
            
            tableView.performBatchUpdates {
                tableView.insertRows(at: newIndexPath, with: .automatic)
            }
        }
    }
}





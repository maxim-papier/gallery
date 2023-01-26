import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    
    private let ShowSingleImageSegueID = "ShowSingleImage"
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
    
    
    
    // When user tap on the cell
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
     if segue.identifier == ShowSingleImageSegueID {
     guard
     let viewController = segue.destination as? SingleImageViewController,
     let indexPath = sender as? IndexPath else { return }
     
     
     let image = UIImage(named: photoNames[indexPath.row])
     viewController.image = image
     } else {
     super.prepare(for: segue, sender: sender)
     }
     
     }
     */
    
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: ShowSingleImageSegueID, sender: indexPath)
        
    }
    
}



// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = imagesListService.photos.count
        print("COUNT = \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier , for: indexPath)
        guard let imagesListCell = cell as? ImagesListCell else {
            fatalError("ImageList cell error")
        }
        
        
        
        let photo = imagesListService.photos[indexPath.row]
        let url = photo.thumbnailImage
        print("PHOTO ID: \(photo.id)")
        print("PHOTO IS IT LIKED?: \(photo.isLiked)")
        
        imagesListCell.previewImage.kf.indicatorType = .activity
        imagesListCell.previewImage.kf.setImage(with: url, placeholder: UIImage(named: "stub"))
        
        let isLiked = photo.isLiked
        
        let image = {
            isLiked == true ? UIImage(named: "likeButton_isActive") :
            UIImage(named: "likeButton_isNotActive")
        }()
        
        imagesListCell.likeButton.setImage(image, for: .normal)
        
        imagesListCell.delegate = self
        
        return imagesListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imagesListService.prepareForDisplay(index: indexPath.row)
    }
    
}


// MARK: - ImagesListCellDelegate


extension ImagesListViewController: imagesListCellDelegate {
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        
        
        guard let indexPath = tableView.indexPath(for: cell),
              indexPath.row < imagesListService.photos.count else {
            return
        }
        
        UIBlockingProgressHUD.show()
        
        let photo = imagesListService.photos[indexPath.row]
        let photoID = photo.id
        let isLiked = photo.isLiked
        
        imagesListService.changeLike(for: photoID, with: !isLiked) { error in
            
            UIBlockingProgressHUD.dismiss()

            if let error {
                assertionFailure("Не лайкнуло \(error)")
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
    /*
     guard let indexPath = tableView.indexPath(for: cell) else { return }
     UIBlockingProgressHUD.show()
     let photo = imagesList.photos[indexPath.row]
     
     imagesList.toggleLike(id: photo.id, isLike: !photo.isLiked) { result in
     switch result {
     case .success(let liked):
     let image: String = liked ? "Like" : "NoLike"
     cell.cellLike.setImage(UIImage(named: image), for: .normal)
     case .failure(let error):
     print(error.localizedDescription)
     }
     }
     UIBlockingProgressHUD.dismiss()
     
     */
    






// MARK: - Observe ImagesList Changes

extension ImagesListViewController {
    
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





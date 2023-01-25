import UIKit
import Kingfisher

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let ShowSingleImageSegueID = "ShowSingleImage"
    private let notificationCenter: NotificationCenter = NotificationCenter()
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
        
        imagesListService.fetchPhotosNextPage()
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: "\(ImagesListCell.self)")
        
        tableView.delegate = self
        tableView.dataSource = self
        
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
        return imagesListService.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(ImagesListCell.self)" , for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            fatalError("ImageList cell error")
        }
        
        let photo = imagesListService.photos[indexPath.row]
        let url = photo.thumbnailImage
        //imagesListCell.imageView?.kf.setImage(with: photo.thumbnailImage)
        imagesListCell.previewImage.kf.setImage(with: url)
        
        /*
         guard let currentPhotoName = UIImage(
             named: photoNames[indexPath.row]) else { return }
         
         cell.previewImage.image = currentPhotoName
         cell.dateLabel.text = dateFormatter.string(from: Date())
         

         */
        
        return imagesListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        imagesListService.prepareForDisplay(index: indexPath.row)
    }
    
}


// MARK: - ImagesListCellDelegate





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





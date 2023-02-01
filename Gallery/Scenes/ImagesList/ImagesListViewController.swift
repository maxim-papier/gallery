import UIKit


protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func cellDidLike(error: Error?, indexPath: IndexPath, isLiked: Bool)
}


class ImagesListViewController: UIViewController {
    
    
    @IBOutlet private var tableView: UITableView!
    
    var presenter: ImagesListPresenterProtocol?
    
    private let showSingleImageSegueID = "ImagesListToSingleImage"
    private let notificationCenter: NotificationCenter = .default
    private var imagesListObserver: NSObjectProtocol?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.load()
        
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
}


// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter?.photosCount ?? 0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ImagesListCell",
            for: indexPath
        ) as! ImagesListCell
        
        presenter?.configCell(for: cell, with: indexPath)
        
        guard let photoURL = presenter?.service.photos[indexPath.row].thumbnailImage else {
            fatalError("ImageList cell error")
        }
        configureImage(cell: cell, with: photoURL)
        
        cell.delegate = self
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.readyForDisplay(index: indexPath.row)
    }
}


extension ImagesListViewController {
    
    func configureImage(cell: ImagesListCell, with photoURL: URL) {
        let thumbnailGradient = AnimatedGradientCreator().getAnimatedLayer(
            width: cell.previewImage.bounds.width,
            height: cell.previewImage.bounds.height,
            radius: 16
        )
        
        cell.previewImage.layer.addSublayer(thumbnailGradient)
        cell.previewImage.layer.zPosition = 1
        
        DispatchQueue.main.async {
            cell.previewImage.kf.setImage(with: photoURL) { _ in
                cell.previewImage.contentMode = .scaleAspectFill
                thumbnailGradient.removeFromSuperlayer()
                cell.previewImage.layer.zPosition = 0
            }
        }
    }
}


// MARK: - ImagesListCellDelegate


extension ImagesListViewController: ImagesListCellDelegate {
    
    func cellDidTapLike(_ cell: ImagesListCell) {
        
        // UIBlockingProgressHUD.show()
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.cellDidTapLike(at: indexPath)
    }
    
    func cellDidLike(error: Error?, indexPath: IndexPath, isLiked: Bool) {
        
        // UIBlockingProgressHUD.dismiss()
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else {
            return
        }
        guard let error = error else {
            
            cell.setLike(isLiked)
            return
        }
        assertionFailure("Like engine is broken :) \(error)")
    }
}


// MARK: - Observe ImagesList Changes

extension ImagesListViewController {
    
    private func observeImagesListChanges() {
        
        let imageService = ImageListService()
        
        imagesListObserver = notificationCenter.addObserver(forName: imageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
    
    private func stopObservingImagesListChanges() {
        if let imagesListObserver {
            notificationCenter.removeObserver(imagesListObserver)
        }
    }
    
    private func updateTableViewAnimated() {
        presenter?.updateTableViewAnimated(tableView: tableView)
    }
}


// When user tap on the cell

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueID, sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard
            segue.identifier == showSingleImageSegueID,
            let viewController = segue.destination as? SingleImageViewController,
            let indexPath = sender as? IndexPath
        else {
            print("Error: Invalid segue — \(segue.destination) or sender")
            return
        }
        let image = presenter?.photo(index: indexPath.row)
        let url = image?.largeImage
        viewController.image = url
    }
    
}





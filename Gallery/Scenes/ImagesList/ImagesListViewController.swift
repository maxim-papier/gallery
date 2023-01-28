import UIKit


class ImagesListViewController: UIViewController {
    
    
    @IBOutlet private var tableView: UITableView!
    
    var presenter: ImagesListPresenterProtocol?
        
    private let ShowSingleImageSegueID = "ImagesListToSingleImage"
    
    private let notificationCenter: NotificationCenter = .default
    private var imagesListObserver: NSObjectProtocol?
        
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.didLoad()

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

// When user tap on the cell


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
        let image = presenter?.photo(index: indexPath.row)
        let url = image?.largeImage
        viewController.image = url
    }
    
}


// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = presenter?.photosCount ?? 0
        return count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier , for: indexPath)
        
        guard let imagesListCell = cell as? ImagesListCell else {
            fatalError("ImageList cell error")
        }
        
        presenter?.configCell(for: imagesListCell, with: indexPath)
        imagesListCell.delegate = self
        
        return imagesListCell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        presenter?.readyForDisplay(index: indexPath.row)

    }
    
}


// MARK: - ImagesListCellDelegate


extension ImagesListViewController: imagesListCellDelegate {
    
    func imagesListCellDidTapLike(_ cell: ImagesListCell) {
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        
        DispatchQueue.main.async {
            UIBlockingProgressHUD.show()
        }
        presenter?.imagesListCellDidTapLike(cell, indexPath: indexPath)
    }
}


// MARK: - Observe ImagesList Changes

extension ImagesListViewController {

    private func observeImagesListChanges() {
        
        let imagesListService = ImageListService()
        
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
        presenter?.updateTableViewAnimated(tableView: tableView)
    }
}





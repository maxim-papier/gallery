import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let ShowSingleImageID = "ShowSingleImage"
    private var photoNames = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        photoNames = Array(0..<20).map{ "\($0)" }
    }
    
    // Utility
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == ShowSingleImageID {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photoNames[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
        
    }
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
}


// MARK: - EXTENTIONS


// Mandatory Table Methods

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIdentifier,
            for: indexPath
        )
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

// Tap on row method
extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageID, sender: indexPath)
    }
    
}

/// Cell configurator

extension ImagesListViewController {
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard let currentPhotoName = UIImage(
            named: photoNames[indexPath.row]) else { return }
        
        cell.previewImage.image = currentPhotoName
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
    
        // Like rules (draft)
        
        let isLiked = isEven(indexPath.row)
        let likePicture = {
            isLiked == true ? UIImage(named: "likeButton_isActive") :
            UIImage(named: "likeButton_isNotActive")
        }()
        cell.likeButton.setImage(likePicture, for: .normal)
        
    }
    
    private func isEven(_ number: Int) -> Bool {
        number % 2 == 0 ? true : false
    }
    
}



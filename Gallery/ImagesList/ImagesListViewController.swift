import UIKit

class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private var photosName = [String]()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        photosName = Array(0..<20).map{ "\($0)" }
    }

    
    // Date formater
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()

    
    
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}


// MARK: - cell configurator

extension ImagesListViewController {

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        
        guard let currentPhotoName = UIImage(named: photosName[indexPath.row]) else {
            return
        }
        
        cell.previewImage.image = currentPhotoName
        cell.dateLabel.text = dateFormatter.string(from: Date())
        
        let isLiked = isEven(indexPath.row)
        let likePicture = isLiked ? UIImage(named: "likeButton_isActive") : UIImage(named: "likeButton_isNotActive")
        cell.likeButton.setImage(likePicture, for: .normal)

    }
    
    private func isEven(_ number: Int) -> Bool {
        number % 2 == 0 ? true : false
    }
     
    
}

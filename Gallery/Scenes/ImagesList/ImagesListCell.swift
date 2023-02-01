import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func cellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBAction func likeButton(_ sender: Any) {
        delegate?.cellDidTapLike(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        previewImage.kf.cancelDownloadTask()
    }
    
    func setLike(_ isLiked: Bool) {

        let image = isLiked ? UIImage(named: "likeButton_isActive") : UIImage(named: "likeButton_isNotActive")
        DispatchQueue.main.async {
            self.likeButton.setImage(image, for: .normal)
        }
    }
}

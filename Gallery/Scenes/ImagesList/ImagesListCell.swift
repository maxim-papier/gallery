import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        #warning("???")
        // fullsizeImageView.kf.cancelDownloadTask
    }
    
    /*
     tableView.reloadRows(at: [indexPath], with: .automatic)
     Предполагается, что метод reloadRows будет вызваться в комплишн-блоке метода kf.setImage.
    */
    
}



import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
    
    @IBOutlet var imageView: UIImageView!
    @IBAction func didTapBackwardButton() {
        dismiss(animated: true)
    }
    
}

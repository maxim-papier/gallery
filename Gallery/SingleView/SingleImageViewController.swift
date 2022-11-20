import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            zoomSettings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        
    }
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBAction func didTapBackwardButton() {
        dismiss(animated: true)
    }
    
}

// MARK: - EXTENTIONS

extension SingleImageViewController {
    func zoomSettings() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}


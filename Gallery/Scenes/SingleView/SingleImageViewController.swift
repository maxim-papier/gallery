import UIKit

class SingleImageViewController: UIViewController {
    
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        applySettings()
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var shareButton: UIButton!
    
    @IBAction func didTapBackwardButton() {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        if let image {
            let share = UIActivityViewController(
                activityItems: [image],
                applicationActivities: nil)
            present(share, animated: true)
        }
    }
}


// MARK: - EXTENTIONS

extension SingleImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

// Setup

extension SingleImageViewController {
    func applySettings() {
        cornerRadiusDidSet()
        zoomSettings()
    }
}

extension SingleImageViewController {
    func zoomSettings() {
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }
}

extension SingleImageViewController {
    func cornerRadiusDidSet() {
        shareButton.layer.cornerRadius = 25
    }
}

// Rescale algorithm

extension SingleImageViewController {
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        // Вычисляю соотношение сторон
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        
        // Нахожу значение зума для того, чтобы картинка была на весь экран
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        
        scrollView.setZoomScale(scale, animated: false)
        
        scrollView.layoutIfNeeded() // Принудительный пересчёт
        
        // Определяю contentOffset для картинки
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
        
    }
    
}


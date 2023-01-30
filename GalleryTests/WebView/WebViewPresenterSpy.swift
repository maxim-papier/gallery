import Gallery
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    
    var view: Gallery.WebViewViewControllerProtocol?
    var viewDidLoadCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) { }
    func code(from url: URL) -> String? { return nil }
}

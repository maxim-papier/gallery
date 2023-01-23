import UIKit

final class AlertService {
        
    init() {}
    
    func showErrorAlert(on vc: UIViewController, error: Error, handler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in handler() }))
        vc.present(alert, animated: true)
    }

}


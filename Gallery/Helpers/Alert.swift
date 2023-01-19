import UIKit

final class AlertService {
    
    private let vc: UIViewController
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    func showErrorAlert(on vc: UIViewController, error: Error) {
        let alert = UIAlertController(title: "Что-то пошло не так", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            DispatchQueue.main.async {
                alert.dismiss(animated: true, completion: nil)
            }
        }))
        vc.present(alert, animated: true)
    }

}


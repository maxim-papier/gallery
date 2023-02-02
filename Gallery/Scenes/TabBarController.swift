import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let storyBoardID = "ImagesListViewController"
        
        guard let vc1 = storyboard.instantiateViewController(withIdentifier: storyBoardID) as? ImagesListViewController else {
            fatalError("Failed to prepare for \(storyboard)")
        }
        
        let service = ImageListService()
        let presenter1 = ImagesListPresenter(service: service)
        vc1.presenter = presenter1
        presenter1.view = vc1
        
        // ---------
        
        let vc2 = ProfileViewController()
        vc2.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: "tab_profile_active"), selectedImage: nil)
        
        let presenter2 = ProfilePresenter(view: vc2, logoutHelper: LogoutHelper())
        presenter2.view = vc2
        vc2.presenter = presenter2
        
        self.viewControllers = [vc1, vc2]
    }
}

import UIKit

final class TabBarController: UITabBarController {
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let storyBoardID = "ImagesListViewController"
        
        guard let imagesListVC = storyboard.instantiateViewController(withIdentifier: storyBoardID) as? ImagesListViewController else {
            fatalError("Failed to prepare for \(storyboard)")
        }
        
        let imageListService = ImageListService()
        
        imagesListVC.presenter = ImagesListPresenter(service: imageListService)
        
        
        let profileVC = ProfileViewController()
        
        profileVC.tabBarItem = UITabBarItem(
            title: nil,
            image: UIImage(named: "tab_profile_active"),
            selectedImage: nil
        )
        profileVC.presenter = ProfilePresenter(view: profileVC, logoutHelper: LogoutHelper())
        
        self.viewControllers = [imagesListVC, profileVC]
        
    }
    
}

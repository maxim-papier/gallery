import UIKit
import Kingfisher

class ProfileViewController: UIViewController {
    

    let token = OAuth2TokenStorage().token
    
    private var profileImageServiceObserver: NSObjectProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        // updateProfile()
        // addObserverForNotifications()
        // updateAvatar()
    }
}


// UI settings

extension ProfileViewController {
    
    private func setUI() {
                
        setBackground()
        setProfileImage()
        setLabels()
    }
}


// Layout


extension ProfileViewController {
 
    private func setBackground() {
        view.backgroundColor = UIColor.redYP
    }
        
}


extension ProfileViewController {
    
    private func setProfileImage() {
        
        let profileImage = UIImage(named: "UserPic.png")
        let imageView = UIImageView(image: profileImage)
                
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        imageView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
                
    }
}

extension ProfileViewController {
    
    
    private func setLabels() {
        
        let nameLabel = UILabel()
    
        nameLabel.text = "Name"
        nameLabel.tintColor = UIColor.blackYP
        nameLabel.font = UIFont.systemFont(ofSize: 18)

        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        nameLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: )
        
    }
}


    //final class ViewController: UIViewController {
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //
    //        let labelOne = UILabel()
    //        let labelTwo = UILabel()
    //        let labelThree = UILabel()
    //
    //
    //        labelOne.text = "ONE"
    //        labelTwo.text = "TWO"
    //        labelThree.text = "THREE"
    //
    //        labelOne.translatesAutoresizingMaskIntoConstraints = false
    //        view.addSubview(labelOne)
    //
    //        labelTwo.translatesAutoresizingMaskIntoConstraints = false
    //        view.addSubview(labelTwo)
    //
    //        labelThree.translatesAutoresizingMaskIntoConstraints = false
    //        view.addSubview(labelThree)
    //
    //
    //        labelOne.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    //        labelOne.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    //
    //        labelTwo.topAnchor.constraint(equalTo: labelOne.bottomAnchor, constant: 8).isActive = true
    //        labelTwo.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    //
    //        labelThree.topAnchor.constraint(equalTo: labelTwo.bottomAnchor, constant: 8).isActive = true
    //        labelThree.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
    //
    //    }
    //
    //}


    //final class ViewController: UIViewController {
    //
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        let redView = UIView()
    //
    //        redView.backgroundColor = .red
    //        view.addSubview(redView)
    //
    //        redView.translatesAutoresizingMaskIntoConstraints = false
    //
    //        redView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    //        redView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    //        redView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    //        redView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    //
    //        ///
    //        ///
    //
    //        let greenView = UIView()
    //
    //        greenView.backgroundColor = .green
    //        view.insertSubview(greenView, belowSubview: redView)
    //
    //        greenView.translatesAutoresizingMaskIntoConstraints = false
    //
    //        greenView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    //        greenView.heightAnchor.constraint(equalToConstant: 500).isActive = true
    //        greenView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    //        greenView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    //
    //    }
    //
    //}


    //redView.backgroundColor = .red
    //
    //redView.translatesAutoresizingMaskIntoConstraints = false
    //view.addSubview(redView)
    //
    //redView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    //redView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    //redView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    //redView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    
//}


// Adding an observer

//extension ProfileViewController {
//
//    private func addObserverForNotifications() {
//
//        profileImageServiceObserver = NotificationCenter.default.addObserver(
//            forName: ProfileImageService.DidChangeNotification,
//            object: nil,
//            queue: .main,
//            using: { [weak self] _ in
//                guard let self else { return }
//                self.updateAvatar()
//            }
//        )
//
//    }
//
//}

// MARK: - UI updates section


//extension ProfileViewController {
//
//    private func updateProfile() {
//
//        let profileService = ProfileService.shared
//        let profile = profileService.profile
//
//        nameLabel.text = profile?.name
//        loginNameLabel.text = profile?.loginName
//        descriptionLabel.text = profile?.bio
//
//    }
//
//}


//extension ProfileViewController {
//
//    func updateAvatar() {
//
//        guard
//            let profileImageURL = ProfileImageService.shared.avatarURL,
//            let url = URL(string: profileImageURL)
//
//        else {
//            print("Error creating URL with profileImageURL = \(String(describing: ProfileImageService.shared.avatarURL))")
//            return
//        }
//
//        DispatchQueue.main.async {
//
//            let cache = ImageCache.default
//            cache.clearMemoryCache()
//            cache.clearDiskCache()
//            self.avatar.kf.indicatorType = .activity
//            self.avatar.kf.setImage(with: url, placeholder: UIImage(named: "placeholder.svg"))
//        }
//
//    }
//
//}

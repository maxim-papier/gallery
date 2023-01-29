@testable import Gallery
import XCTest


final class ProfileViewTest: XCTestCase {
    
        
    func test
    
    
    
    
}







//    func testPresenterUpdatesProfileData() {
//
//        ///given
//        let vc = ProfileViewController()
//        let presenter = ProfilePresenterMock()
//        vc.presenter = presenter
//
//        /// when
//        _ = vc.view
//        presenter.updateProfile()
//        sleep(2)
//
//        /// then
//        print("LOGIN --- \(vc.loginNameLabel.text!)")
//        XCTAssertEqual(vc.loginNameLabel.text!, "@deadman")
//    }
//
//
//
//    /*
//     final class ProfileViewTests: XCTestCase {
//         func testProfileInfo() {
//             // given
//             let storyboard = UIStoryboard(name: "Main", bundle: nil)
//             guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController
//             else { return }
//             let presenter = ProfileViewPresenterSpy()
//             viewController.presenter = presenter
//
//             // when
//             _ = viewController.view
//             presenter.updateProfileDetails()
//
//             // then
//             XCTAssertEqual(viewController.profileAccountName.text, "user001")
//         }
//     }
//
//     */
//
//
//
//
//
//
//    // The ProfileVС calls the presenter's viewDidLoad method.
//    // Let's check that this is really happening.
//
//    func testVCCallsViewDidLoad() {
//        // given
//        let vc = ProfileViewController()
//        let helper = LogoutHelper()
//        let presenter = ProfilePresenterSpy(logoutHelper: helper, view: vc)
//        vc.presenter = presenter
//
//        // when
//        _ = vc.view
//        vc.viewDidLoad()
//
//        // then
//        XCTAssertTrue(presenter.viewDidLoadCalled)
//    }
//
//
//    // Check whether the presenter calls the avatarUpdate() method
//    // of the VC after the viewDidLoad() load
//
//    func testPresenterCallsAvatarUpdateInViewDidLoad() {
//        // given
//        let vc = ProfileViewController()
//        let helper = LogoutHelper()
//        let presenter = ProfilePresenterSpy(logoutHelper: helper, view: vc)
//        vc.presenter = presenter
//
//        // when
//        _ = vc.view
//
//        vc.viewDidLoad()
//
//        // then
//        XCTAssertTrue(presenter.updateAvatarCalled)
//    }
//
//



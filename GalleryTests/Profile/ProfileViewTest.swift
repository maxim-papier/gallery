@testable import Gallery
import XCTest


final class ProfileViewTest: XCTestCase {
    
    
    // Let's check if the loginName on the ProfileVC
    // are updated when the presenter method updateProfile()
    // is called
        
    func testPresenterUpdatesLoginNameLabelVC() {

        ///given
        let vc = ProfileViewController()
        let presenter = ProfilePresenterMock()
        vc.presenter = presenter
        presenter.view = vc
        
        /// when
        _ = vc.view
        presenter.updateProfile()

        /// then
        XCTAssertEqual(vc.loginNameLabel.text!, "@deadman")
    }
    
    // Let's check if the nameLabel on the ProfileVC
    // are updated when the presenter method updateProfile()
    // is called

    
    func testPresenterUpdatesNameLabelVC() {

        ///given
        let vc = ProfileViewController()
        let presenter = ProfilePresenterMock()
        vc.presenter = presenter
        presenter.view = vc
        
        /// when
        _ = vc.view
        presenter.updateProfile()

        /// then
        XCTAssertEqual(vc.nameLabel.text!, "William Blake")
    }

    
    // Let's check if the descriptionLabelVC on the ProfileVC
    // are updated when the presenter method updateProfile()
    // is called

    
    func testPresenterUpdatesDescriptionLabelVC() {

        ///given
        let vc = ProfileViewController()
        let presenter = ProfilePresenterMock()
        vc.presenter = presenter
        presenter.view = vc
        
        /// when
        _ = vc.view
        presenter.updateProfile()

        /// then
        XCTAssertEqual(vc.descriptionLabel.text!, "I'm an accountant from Cleveland, Ohio. I've recently taken up a job in the town of Machine, but things have not gone as planned. I'm currently on the run and trying to survive in the wild west.")
    }

    
    // Let's check whether the helper sends the task to show
    // the alert and the alert itself.
    
    func testLogutHelperOrderAlert() {
        
        ///given
        let vc = ProfileVCSpy()
        let logoutHelper = LogoutHelper()
        let presenter = ProfilePresenter(view: vc, logoutHelper: logoutHelper)
        vc.presenter = presenter
        
        /// when
        _ = presenter.view
        presenter.didTapLogout()
        
        /// then
        XCTAssertTrue(vc.gotAlertToShow)
        
    }

    
    
}




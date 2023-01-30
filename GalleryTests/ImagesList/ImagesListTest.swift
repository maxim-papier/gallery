@testable import Gallery
import XCTest
import UIKit


final class ImagesListTest: XCTestCase {
    
    
    func testVCCallsLoad() {
        
        ///given
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let storyBoardID = "ImagesListViewController"

        let vc = storyboard.instantiateViewController(withIdentifier: storyBoardID) as? ImagesListViewController
        
        let presenter = ImagesListPresenterSpy()
        vc?.presenter = presenter
        
        
        /// when
        let _ = vc?.view
        
        ///then
        XCTAssertTrue(presenter.loadDidCalled)
    }
}

import Foundation

final class ProfilePresenterMock: ProfilePresenterProtocol {
    
    var view: ProfileViewControllerProtocol?
    
    func didTapYes() { }
    
    func updateProfile() {
        
        let profile = Profile(
            result: ProfileResult(
                username: "deadman",
                firstName: "William",
                lastName: "Blake",
                bio: "I'm an accountant from Cleveland, Ohio. I've recently taken up a job in the town of Machine, but things have not gone as planned. I'm currently on the run and trying to survive in the wild west."
            )
        )
        print("PRO-------\(profile)")
        view?.updateProfile(profile: profile)
        

        
        
    }
    
    func didTapLogout() {
        
    }
    
    func viewDidLoad() {}
    func updateAvatar() {}
}

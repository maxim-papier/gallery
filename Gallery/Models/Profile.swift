import Foundation

struct Profile {
    let username: String
    let name: String
    let loginName: String
    let bio: String?

    init(result: ProfileResult) {
        username = result.username
        name = result.firstName + " " + result.lastName
        loginName = "@" + result.username
        bio = result.bio
    }
    
}


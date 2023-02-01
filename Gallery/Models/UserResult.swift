import Foundation

struct UserResult: Decodable {
    let profileImage: Sizes
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
}

struct Sizes: Codable {
    
    let small: String?
    let medium: String?
    let large: String?
    
}



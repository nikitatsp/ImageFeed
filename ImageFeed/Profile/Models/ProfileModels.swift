import Foundation

struct CurentUser: Codable {
    var username: String
}

struct ProfileImage: Codable {
    let small: String
    let medium: String
    let large: String
}

struct PublicProfile: Codable {
    let username: String
    let name: String
    let bio: String?
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case username
        case name
        case bio
        case profileImage = "profile_image"
    }
}

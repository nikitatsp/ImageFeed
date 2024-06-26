import UIKit

struct OAuth2TokenStorage {
    
    private init() {}
    
    static var token: String {
        get {
            guard let string = UserDefaults.standard.string(forKey: "BearerToken") else {return ""}
            return string
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "BearerToken")
        }
    }
}

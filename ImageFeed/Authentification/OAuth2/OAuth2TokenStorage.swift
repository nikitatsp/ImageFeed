import UIKit
import KeychainAccess

struct OAuth2TokenStorage {
    static private let keychain = Keychain(service: "com.imagefeed.keys")
    private init() {}
    
    static var token: String {
        get {
            do {
                let token = try keychain.get("bearerToken")
                guard let token else {return ""}
                return token
            } catch {
                print(error.localizedDescription)
                return ""
            }
        }
        set {
            do {
                try keychain.set(newValue, key: "bearerToken")
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
}

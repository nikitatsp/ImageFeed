import Foundation

protocol ProfileResultDelegate: AnyObject {
    func didRecieveProfile()
}

final class ProfileResult {
    static let shared = ProfileResult()
    var profile: PublicProfile?
    weak var delegate: ProfileResultDelegate?
    private init() {}
    
    func fetchProfile() {
        let token = OAuth2TokenStorage.token
        guard let url = URL(string: "\(Constants.defaultBaseURL.absoluteString)/me") else {return}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.fetch(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(CurentUser.self, from: data)
                    self?.fetchPublicProfile(username: model.username, token: token)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    private func fetchPublicProfile(username: String?, token: String) {
        guard let username else {return}
        guard let url = URL(string: "\(Constants.defaultBaseURL.absoluteString)/users/\(username)") else {return}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.fetch(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let profile = try JSONDecoder().decode(PublicProfile.self, from: data)
                    ProfileResult.shared.profile = profile
                    DispatchQueue.main.async {
                        self?.delegate?.didRecieveProfile()
                    }
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }.resume()
    }
}

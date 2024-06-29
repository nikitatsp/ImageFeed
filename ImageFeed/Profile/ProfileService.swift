import UIKit

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    
    func fetchProfile(token: String, completion: @escaping(Result<Profile, Error>) -> Void) {
        let token = OAuth2TokenStorage.token
        guard let url = URL(string: "\(Constants.defaultBaseURL.absoluteString)/me") else {return}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        NetworkManager.shared.fetch(request: request) { [weak self] result in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(ProfileResult.self, from: data)
                    let profile = Profile(userProfile: model)
                    self?.profile = profile
                    completion(.success(profile))
                } catch {
                    print("ProfileService/fetchProfile: parseError: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("ProfileService/fetchProfile: fetchError: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}

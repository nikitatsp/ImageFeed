import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    private init() {}
    
    private (set) var avatarURL: String?
    let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(token: String, username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(Constants.defaultBaseURL.absoluteString)/users/\(username)") else {return}
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        NetworkManager.shared.fetch(request: request) { [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let data):
                do {
                    let profileImage = try JSONDecoder().decode(UserResult.self, from: data)
                    avatarURL = profileImage.profileImage?.large
                    guard let avatarURL else {return}
                    NotificationCenter.default.post(name: self.didChangeNotification, object: self)
                    completion(.success(avatarURL))
                } catch {
                    print("ProfileImageService/fetchProfileImageURL: parseError: \(error.localizedDescription)")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("ProfileImageService/fetchProfileImageURL: fetchError: \(error.localizedDescription)")
                completion(.failure(error))
            }
        }.resume()
    }
}

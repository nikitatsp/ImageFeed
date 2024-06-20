import UIKit

//MARK: - JsonBearerTokenModel

struct JsonBearerTokenModel: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
}

//MARK: - OAuthTokenResponseBody

struct OAuthTokenResponseBody {
    
    static let shared = OAuthTokenResponseBody()
    private init() {}
    
    func decodeData(request: URLRequest, handler: @escaping(_ result: Result<JsonBearerTokenModel, Error>) -> Void) {
        NetworkManager.shared.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(JsonBearerTokenModel.self, from: data)
                    handler(.success(model))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

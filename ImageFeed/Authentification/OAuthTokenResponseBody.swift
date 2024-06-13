import UIKit

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
                    print("Ошибка декодирования")
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}

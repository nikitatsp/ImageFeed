import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    func makeOAuthTokenRequest(code: String) -> URLRequest? {
        guard var urlComponents = URLComponents(string: "https://unsplash.com/oauth/token") else {
            return nil
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "client_secret", value: Constants.secretKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        guard let url = urlComponents.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        return request
    }
    
    enum NetworkError: Error, LocalizedError {
        case noData
        case codeError(Int)
        
        var errorDescription: String? {
            switch self {
            case .noData:
                return "Data is empty"
            case .codeError(let statusCode):
                return "Code error: \(statusCode)"
            }
        }
    }
    
    func fetchOAuthToken(code: String, handler: @escaping(_ result :Result<String, Error>) -> Void) {
        guard let request = makeOAuthTokenRequest(code: code) else {return}
        
        OAuthTokenResponseBody.shared.decodeData(request: request) { result in
            switch result {
            case .success(let model):
                let token = model.accessToken
                print(token)
                handler(.success(token))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


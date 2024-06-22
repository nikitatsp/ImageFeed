import UIKit

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    private var lastCode: String?
    private var task: URLSessionTask?
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest? {
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
    
    func fetchOAuthToken(code: String, handler: @escaping(_ result: Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        if task != nil {
            if code == lastCode {
                return
            } else {
                task?.cancel()
            }
        }
        
        lastCode = code
        guard let request = makeOAuthTokenRequest(code: code) else {
            handler(.failure(NetworkError.requestError))
            return
        }
        
        task = NetworkManager.shared.fetch(request: request, completion: { result in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(JsonBearerTokenModel.self, from: data)
                    let token = model.accessToken
                    DispatchQueue.main.async {
                        handler(.success(token))
                    }
                } catch {
                    DispatchQueue.main.async {
                        handler(.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    handler(.failure(error))
                }
            }
        })
        task?.resume()
    }
}




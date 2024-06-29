import UIKit
import WebKit

//MARK: - WebViewConstants

enum WebViewConstants {
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
}

//MARK: - WebViewViewControllerDelegateProtocol

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel()
}

//MARK: - WebViewViewController

final class WebViewViewController: UIViewController {
    private var progressView = UIProgressView()
    private var webView = WKWebView()
    private var backBarButton = UIBarButtonItem()
    private var estimatedProgressObservation: NSKeyValueObservation?
    weak var delegate: AuthViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP White")
        configureWebView()
        configureProgressView()
        configureBackBarButton()
        setConstraints()
        loadAuthView()
        webView.navigationDelegate = self
        observeProgress()
        
    }
    
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            print("WebViewViewController/loadAuthView: urlError: urlScheme is nil")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.accessKey),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("WebViewViewController/loadAuthView: urlComponentsError: parametres is nil")
            return
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func configureWebView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureProgressView() {
        progressView.progressViewStyle = .bar
        progressView.progressTintColor = UIColor(named: "YP Black")
        view.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureBackBarButton() {
        navigationItem.leftBarButtonItem = backBarButton
        backBarButton.image = UIImage(named: "Backward Black")
        backBarButton.tintColor = UIColor(named: "YP Black")
        backBarButton.target = self
        backBarButton.action = #selector(didBackButtonTapped)
    }
    
    @objc func didBackButtonTapped() {
        delegate?.webViewViewControllerDidCancel()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - KVO

extension WebViewViewController {
    private func observeProgress() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

//MARK: - WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" })
        {
            return codeItem.value
        } else {
            return nil
        }
    }
}

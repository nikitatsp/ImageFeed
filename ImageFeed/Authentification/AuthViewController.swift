import UIKit
import ProgressHUD

protocol AuthViewControllerDelegate: AnyObject {
    func didRecieveBearerToken()
}

final class AuthViewController: UIViewController {
    
    weak var delegate: AuthViewControllerDelegate?
    private let loginButton = UIButton()
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        configureLoginButton()
        configureLogoImageView()
    }
    
    private func configureLogoImageView() {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "Logo_of_Unsplash")
        view.addSubview(logoImageView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func configureLoginButton() {
        loginButton.addTarget(self, action: #selector(didTappedLoginButton), for: .touchUpInside)
        loginButton.backgroundColor = UIColor.white
        loginButton.setTitle("Войти", for: .normal)
        loginButton.setTitleColor(UIColor(named: "YP Black"), for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        loginButton.layer.cornerRadius = 16
        loginButton.layer.masksToBounds = true
        view.addSubview(loginButton)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90).isActive = true
    }
    
    @objc private func didTappedLoginButton() {
        let webViewController = WebViewViewController()
        webViewController.delegate = self
        navigationController?.pushViewController(webViewController, animated: true)
    }
}

//MARK: - WebViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)
        loginButton.isEnabled = false
        ProgressHUD.animate()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            switch result{
            case .success(let token):
                OAuth2TokenStorage.token = token
                ProgressHUD.dismiss()
                self?.delegate?.didRecieveBearerToken()
                self?.loginButton.isEnabled = true
            case .failure(let error):
                print(error.localizedDescription)
                ProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Попробовать еще раз", style: .default) {_ in 
                    self?.loginButton.isEnabled = true
                }
                alertController.addAction(alertAction)
                self?.present(alertController, animated: true)
            }
        }
    }
    
    func webViewViewControllerDidCancel() {
        navigationController?.popViewController(animated: true)
    }
}

import UIKit

class AuthViewController: UIViewController {
    
    let loginButton = UIButton()
    let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        configureLoginButton()
        configureLogoImageView()
        configureBackButton()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "ShowWebView" else {return}
        guard let destinationVC = segue.destination as? WebViewViewController else {return}
        destinationVC.delegate = self
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
    
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: "Backward Black")
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "Backward Black")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: "YP Black")
    }
    
    @objc private func didTappedLoginButton() {
        performSegue(withIdentifier: "ShowWebView", sender: nil)
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            switch result{
                
            case .success(let token):
                OAuth2TokenStorage.token = token
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        
    }
}

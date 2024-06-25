import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    private let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        configureImageView(imageView: imageView)
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage.token == "" {
            presentAuthViewController()
        } else {
            ProfileResult.shared.delegate = self
            ProfileResult.shared.fetchProfile()
        }
    }
    
    func configureImageView(imageView: UIImageView) {
        let image = UIImage(named: "StartLogo")
        imageView.image = image
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//MARK: - switchToTabBarController

extension SplashViewController {
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        
        window.rootViewController = tabBarController
    }
}

//MARK: - SegueToAuth

extension SplashViewController {
    func presentAuthViewController() {
        let navigationController = NavigationController(rootViewController: AuthViewController())
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController {
    func didRecieveBearerToken() {
        dismiss(animated: true)
        ProfileResult.shared.delegate = self
        ProfileResult.shared.fetchProfile()
    }
}

//MARK: - ProfileResultDelegate

extension SplashViewController: ProfileResultDelegate {
    func didRecieveProfile() {
        switchToTabBarController()
    }
}

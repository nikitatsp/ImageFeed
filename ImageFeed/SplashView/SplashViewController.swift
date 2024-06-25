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
        
        let tabBarController = UITabBarController()
        
        let imageListVC = ImageListViewController()
        let profileVC = ProfileViewController()
        imageListVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "tab_editorial_active"), selectedImage: nil)
        profileVC.tabBarItem = UITabBarItem(title: "",image: UIImage(named: "tab_profile_active"),selectedImage: nil)
        
        tabBarController.tabBar.tintColor = UIColor(named: "YP White")
        tabBarController.tabBar.barTintColor = UIColor(named: "YP Black")
        tabBarController.tabBar.backgroundColor = UIColor(named: "YP Black")
        tabBarController.tabBar.isTranslucent = false
        tabBarController.viewControllers = [imageListVC, profileVC]
        
        window.rootViewController = tabBarController
    }
}

//MARK: - SegueToAuth

extension SplashViewController {
    func presentAuthViewController() {
        let authVC = AuthViewController()
        authVC.delegate = self
        let navigationController = UINavigationController(rootViewController: authVC)
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

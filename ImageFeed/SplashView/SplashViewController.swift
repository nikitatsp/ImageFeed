import UIKit

final class SplashViewController: UIViewController {
    private let imageView = UIImageView()
    private var shouldPresentAuthViewController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        configureImageView(imageView: imageView)
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldPresentAuthViewController {
            if OAuth2TokenStorage.token == "" {
                presentAuthViewController()
            } else {
                let token = OAuth2TokenStorage.token
                fetcProfile(token: token)
            }
        }
    }
    
    private func configureImageView(imageView: UIImageView) {
        let image = UIImage(named: "StartLogo")
        imageView.image = image
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
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
    private func presentAuthViewController() {
        let authVC = AuthViewController()
        authVC.delegate = self
        let navigationController = UINavigationController(rootViewController: authVC)
        navigationController.modalPresentationStyle = .fullScreen
        shouldPresentAuthViewController = false
        present(navigationController, animated: true)
    }
}

//MARK: - FetchProfile

extension SplashViewController {
    
    private func fetcProfile(token: String) {
        ProfileService.shared.fetchProfile(token: token) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let profile):
                    ProfileImageService.shared.fetchProfileImageURL(token: token, username: profile.userName) { [weak self] result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(_):
                                self?.switchToTabBarController()
                            case .failure(let error):
                                print("SplashViewController/fetcProfile: ошибка получения imageURL: \(error.localizedDescription)")
                                self?.presentAuthViewController()
                            }
                        }
                    }
                case .failure(let error):
                    print("SplashViewController/fetcProfile: ошибка получения профиля: \(error.localizedDescription)")
                    self?.presentAuthViewController()
                }
            }
        }
    }
}

//MARK: - AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    
    func didRecieveBearerToken(token: String, vc: AuthViewController) {
        dismiss(animated: true)
        fetcProfile(token: token)
    }
}

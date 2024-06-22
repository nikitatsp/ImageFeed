import UIKit

final class SplashViewController: UIViewController, AuthViewControllerDelegate {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage.token.isEmpty {
            performSegue(withIdentifier: "showAuthorization", sender: nil)
        } else {
            ProfileResult.shared.delegate = self
            ProfileResult.shared.fetchProfile()
        }
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAuthorization" {
            if let navController = segue.destination as? UINavigationController,
               let authVC = navController.topViewController as? AuthViewController {
                authVC.delegate = self
            }
        }
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

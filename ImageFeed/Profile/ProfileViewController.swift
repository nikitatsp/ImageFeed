import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let imageProfileView = UIImageView()
    private let nameLabel = UILabel()
    private let nickNameLabel = UILabel()
    private let statusLabel = UILabel()
    private let exitButton = UIButton()
    private var shouldUpdateImageView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        setupViews()
        addObserver()
        configureLabel(label: nameLabel, text: ProfileService.shared.profile?.name, font: UIFont.systemFont(ofSize: 23, weight: .bold), textColor: .ypWhite)
        configureLabel(label: nickNameLabel, text: ProfileService.shared.profile?.loginName, font: UIFont.systemFont(ofSize: 13), textColor: .ypGray)
        configureLabel(label: statusLabel, text: ProfileService.shared.profile?.bio, font: UIFont.systemFont(ofSize: 13), textColor: .ypWhite)
        configureButton(button: exitButton, imageButton: UIImage(named: "ExitButton"))
        setContstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadius()
    }
    
    private func setCornerRadius() {
        imageProfileView.layer.cornerRadius = imageProfileView.bounds.size.width / 2
        imageProfileView.clipsToBounds = true
        
    }
    
    private func setupViews() {
        view.addSubview(imageProfileView)
        imageProfileView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nickNameLabel)
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureImageView(imageView: UIImageView, imageUrl: String?) {
        guard let imageUrl else {return}
        let url = URL(string: imageUrl)
        imageView.kf.setImage(with: url)
    }
    
    private func configureLabel(label: UILabel, text: String?, font: UIFont, textColor: UIColor) {
        label.text = text
        label.font = font
        label.textColor = textColor
    }
    
    private func configureButton(button: UIButton, imageButton: UIImage?) {
        button.setImage(imageButton, for: .normal)
    }
    
    private func setContstraints() {
        NSLayoutConstraint.activate([
            imageProfileView.widthAnchor.constraint(equalToConstant: 70),
            imageProfileView.heightAnchor.constraint(equalToConstant: 70),
            imageProfileView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            imageProfileView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: imageProfileView.bottomAnchor, constant: 8),
            
            nickNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statusLabel.topAnchor.constraint(equalTo: nickNameLabel.bottomAnchor, constant: 8),
            
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -24),
            exitButton.centerYAnchor.constraint(equalTo: imageProfileView.centerYAnchor)
        ])
    }
}

//MARK: - Observer

extension ProfileViewController {
    func addObserver() {
        NotificationCenter.default.addObserver(forName: ProfileImageService.shared.didChangeNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            self.configureImageView(imageView: self.imageProfileView, imageUrl: ProfileImageService.shared.avatarURL)
            shouldUpdateImageView = false
        }
        
        if let imageURL = ProfileImageService.shared.avatarURL, shouldUpdateImageView {
            configureImageView(imageView: self.imageProfileView, imageUrl: imageURL)
        }
    }
}

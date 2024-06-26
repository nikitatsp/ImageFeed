import UIKit
import Kingfisher
import SkeletonView

class ProfileViewController: UIViewController {
    
    private let imageProfileView = UIImageView()
    private let nameLabel = UILabel()
    private let nameView = UIView()
    private let nickNameLabel = UILabel()
    private let nickNameView = UIView()
    private let statusLabel = UILabel()
    private let statusView = UIView()
    private let exitButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        showSkeleton()
        observe()
        ProfileResult.shared.fetchProfile()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setCornerRadius()
    }
    
    private func setCornerRadius() {
        imageProfileView.layer.cornerRadius = imageProfileView.bounds.size.width / 2
        imageProfileView.clipsToBounds = true
        
        nameView.layer.cornerRadius = 9
        nameView.clipsToBounds = true
        
        nickNameView.layer.cornerRadius = 9
        nickNameView.clipsToBounds = true
        
        statusView.layer.cornerRadius = 9
        statusView.clipsToBounds = true
    }
    
    private func showSkeleton() {
        setupViews()
        setContstraints()
        
        guard let firstColor = UIColor(named: "FirstGradientSkeletonColor") else {return}
        guard let secondColor = UIColor(named: "SecondGradientSkeletonColor") else {return}
        let skeletonGradient = SkeletonGradient(baseColor: firstColor, secondaryColor: secondColor)
        imageProfileView.isSkeletonable = true
        nameView.isSkeletonable = true
        nickNameView.isSkeletonable = true
        statusView.isSkeletonable = true
        imageProfileView.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
        nameView.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
        nickNameView.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
        statusView.showAnimatedGradientSkeleton(usingGradient: skeletonGradient)
    }
    
    private func setupViews() {
        view.addSubview(imageProfileView)
        imageProfileView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameView)
        nameView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(nickNameLabel)
        nickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nickNameView)
        nickNameView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(statusLabel)
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(exitButton)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureImageView(imageView: UIImageView, image: UIImage?, imageUrl: String?) {
        if let image {
            imageView.image = image
        } else if let imageUrl {
            let url = URL(string: imageUrl)
            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(_):
                    imageView.hideSkeleton()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
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
            
            nameView.widthAnchor.constraint(equalToConstant: 223),
            nameView.heightAnchor.constraint(equalToConstant: 18),
            nameView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameView.topAnchor.constraint(equalTo: imageProfileView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: imageProfileView.bottomAnchor, constant: 8),
            
            nickNameView.widthAnchor.constraint(equalToConstant: 89),
            nickNameView.heightAnchor.constraint(equalToConstant: 18),
            nickNameView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nickNameView.topAnchor.constraint(equalTo: nameView.bottomAnchor, constant: 8),
            nickNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nickNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            statusView.widthAnchor.constraint(equalToConstant: 67),
            statusView.heightAnchor.constraint(equalToConstant: 18),
            statusView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statusView.topAnchor.constraint(equalTo: nickNameView.bottomAnchor, constant: 8),
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
    private func observe() {
        NotificationCenter.default.addObserver(forName: ProfileResult.shared.didChangeNotification, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            
            guard let profile = ProfileResult.shared.profile else {return}
            self.configureLabel(label: nameLabel, text: profile.name, font: UIFont.systemFont(ofSize: 23, weight: .bold), textColor: .ypWhite)
            self.configureLabel(label: nickNameLabel, text: "@\(profile.username)", font: UIFont.systemFont(ofSize: 13), textColor: .ypGray)
            self.configureLabel(label: statusLabel, text: profile.bio, font: UIFont.systemFont(ofSize: 13), textColor: .ypWhite)
            
            self.nameView.hideSkeleton()
            self.nickNameView.hideSkeleton()
            self.statusView.hideSkeleton()
            
            self.configureImageView(imageView: imageProfileView, image: nil, imageUrl: profile.profileImage.large)
        }
    }
}

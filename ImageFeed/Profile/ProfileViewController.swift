import UIKit

class ProfileViewController: UIViewController {
    
    private let imageProfileView = UIImageView()
    private let nameLabel = UILabel()
    private let nickNameLabel = UILabel()
    private let statusLabel = UILabel()
    private let exitButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImageView(imageView: imageProfileView, image: UIImage(named: "MockPhotoProfile"))
        configureLabel(label: nameLabel, text: "Екатерина Новикова", font: UIFont.systemFont(ofSize: 23, weight: .bold), textColor: .ypWhite)
        configureLabel(label: nickNameLabel, text: "@ekaterina_nov", font: UIFont.systemFont(ofSize: 13), textColor: .ypGray)
        configureLabel(label: statusLabel, text: "Hello, world!", font: UIFont.systemFont(ofSize: 13), textColor: .ypWhite)
        configureButton(button: exitButton, imageButton: UIImage(named: "ExitButton"))
        
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
    
    private func configureImageView(imageView: UIImageView, image: UIImage?) {
        imageView.image = image
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLabel(label: UILabel, text: String, font: UIFont, textColor: UIColor) {
        label.text = text
        label.font = font
        label.textColor = textColor
        
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureButton(button: UIButton, imageButton: UIImage?) {
        button.setImage(imageButton, for: .normal)
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

import UIKit

final class ImageListViewCell: UITableViewCell {
    static let reuseIdentifier = "ImageListCell"
    
    var imageViewOne = UIImageView()
    var likeButton = UIButton()
    private var fadeView = UIImageView()
    var dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .clear
        configureImageViewOne()
        configureLikeButton()
        configureFadeView()
        configureDateLabel()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureImageViewOne()
        configureLikeButton()
        configureFadeView()
        configureDateLabel()
        setConstraints()
    }
    
    private func configureImageViewOne() {
        imageViewOne.contentMode = .scaleAspectFill
        imageViewOne.layer.masksToBounds = true
        imageViewOne.layer.cornerRadius = 16
        contentView.addSubview(imageViewOne)
        imageViewOne.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureLikeButton() {
        contentView.addSubview(likeButton)
        likeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureFadeView() {
        fadeView.contentMode = .scaleAspectFill
        fadeView.image = UIImage(named: "Gradient")
        contentView.addSubview(fadeView)
        fadeView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func configureDateLabel() {
        dateLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = UIColor(named: "YP White")
        contentView.addSubview(dateLabel)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageViewOne.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            imageViewOne.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            imageViewOne.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageViewOne.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.topAnchor.constraint(equalTo: imageViewOne.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: imageViewOne.trailingAnchor),
            
            fadeView.bottomAnchor.constraint(equalTo: imageViewOne.bottomAnchor),
            fadeView.leadingAnchor.constraint(equalTo: imageViewOne.leadingAnchor),
            fadeView.trailingAnchor.constraint(equalTo: imageViewOne.trailingAnchor),
            fadeView.heightAnchor.constraint(equalToConstant: 30),
            
            dateLabel.bottomAnchor.constraint(equalTo: imageViewOne.bottomAnchor, constant: -4),
            dateLabel.leadingAnchor.constraint(equalTo: imageViewOne.leadingAnchor, constant: 4)
        ])
    }
}

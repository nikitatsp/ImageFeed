import UIKit

final class ImageListViewController: UIViewController {

    private var tableView = UITableView()
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "YP Black")
        configureTableView()
        setConstraints()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(ImageListViewCell.self, forCellReuseIdentifier: ImageListViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.rowHeight = 200
        tableView.backgroundColor = .clear
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

//MARK: - ConfigureCell

extension ImageListViewController {
    private func configCell(for cell: ImageListViewCell, indexPath: IndexPath) {
        let photoName = photosName[indexPath.row]
        
        let currentDate = Date()
        
        let nonActiveLikeButtonImage = UIImage(named: "NonActiveButton")
        let activeLikeButtonImage = UIImage(named: "ActiveButton")
        
        cell.imageViewOne.image = UIImage(named: photoName)
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        cell.backgroundColor = .clear
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.setImage(nonActiveLikeButtonImage, for: .normal)
        } else {
            cell.likeButton.setImage(activeLikeButtonImage, for: .normal)
        }
    }
    
    
}

//MARK: - UITableViewDataSource

extension ImageListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageListViewCell.reuseIdentifier, for: indexPath)
        guard let imageListViewCell = cell as? ImageListViewCell else {
            return UITableViewCell()
        }
        configCell(for: imageListViewCell, indexPath: indexPath)
        return imageListViewCell
    }
    
    
}

//MARK: - UITableViewDelegate

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let singleImageVC = SingleImageViewController()
        singleImageVC.image = UIImage(named: photosName[indexPath.row])
        singleImageVC.modalPresentationStyle = .fullScreen
        present(singleImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return 0 }
        
        let insets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - insets.left - insets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + insets.top + insets.bottom
        return cellHeight
    }
}



import UIKit

final class ImageListViewController: UIViewController {
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configCell(for cell: ImageListViewCell, indexPath: IndexPath) {
        let photoName = photosName[indexPath.row]
        
        let currentDate = Date()
        
        let nonActiveLikeButtonImage = UIImage(named: "NonActiveButton")
        let activeLikeButtonImage = UIImage(named: "ActiveButton")
        
        cell.imageViewOne.image = UIImage(named: photoName)
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        
        if indexPath.row % 2 == 0 {
            cell.likeButton.setImage(nonActiveLikeButtonImage, for: .normal)
        } else {
            cell.likeButton.setImage(activeLikeButtonImage, for: .normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            let image = UIImage(named: photosName[indexPath.row])
            
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

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

extension ImageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImageListViewCell.reuseIdentifier) as? ImageListViewCell else {
            return 200
        }
        
        let imageViewWidth = cell.imageViewOne.frame.size.width
        
        let photoName = photosName[indexPath.row]
        guard let imageHeight = UIImage(named: photoName)?.size.height else {return 200}
        guard let imageWidth = UIImage(named: photoName)?.size.width else {return 200}
        
        return 8 + ((imageViewWidth * imageHeight) / imageWidth)
    }
}


import UIKit

final class ImageListViewCell: UITableViewCell {
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var imageViewOne: UIImageView!
    
    
    static let reuseIdentifier = "ImageListCell"
    
    
}

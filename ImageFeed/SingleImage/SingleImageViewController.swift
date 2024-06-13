import UIKit

class SingleImageViewController: UIViewController {

    @IBOutlet private var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backwardButton: UIButton!
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded, let image else { return }

            imageView.image = image
            imageView.frame.size = image.size
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image else {return}
        imageView.image = image
        imageView.frame.size = image.size
        setEmptyButtonTittle(button: backwardButton)
        
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    
    @IBAction func backwardButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        guard let image else {return}
        let viewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(viewController, animated: true)
    }
}

//MARK: - setEmptyButtonTittle

extension SingleImageViewController {
    private func setEmptyButtonTittle(button: UIButton) {
        button.setTitle("", for: .normal)
        button.setTitle("", for: .highlighted)
        button.setTitle("", for: .selected)
        button.setTitle("", for: .disabled)
    }
}

//MARK: - Rescale

extension SingleImageViewController {
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, min(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
    
    private func centerImageInScrollView(image: UIImage) {
        let vInset = max((scrollView.bounds.size.height - scrollView.contentSize.height) / 2, 0)
        let hInset = max((scrollView.bounds.size.width - scrollView.contentSize.width) / 2, 0)
        
        scrollView.contentInset = UIEdgeInsets(top: vInset, left: hInset, bottom: vInset, right: hInset)
        
    }
}

//MARK: - UIScrollViewDelegate

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        guard let image else {return}
        centerImageInScrollView(image: image)
    }
}

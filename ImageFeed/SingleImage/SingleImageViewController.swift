import UIKit

class SingleImageViewController: UIViewController {
    
    private var scrollView = UIScrollView()
    private var imageView = UIImageView()
    private var backwardButton = UIButton()
    private var shareButton = UIButton()
    
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
        view.backgroundColor = UIColor(named: "YP Black")
        guard let image else {return}
        
        configureScrollView()
        configureImageView(image: image)
        configureBackwardButton()
        configureShareButton()
        setConstraints()
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    private func configureScrollView() {
        scrollView.backgroundColor = UIColor(named: "YP Black")
        scrollView.delegate = self
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureImageView(image: UIImage) {
        imageView.image = image
        imageView.frame.size = image.size
        imageView.contentMode = .scaleAspectFit
        imageView.frame.origin = CGPoint(x: 0, y: 0)
        scrollView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureBackwardButton() {
        backwardButton.setImage(UIImage(named: "Backward"), for: .normal)
        backwardButton.addTarget(self, action: #selector(backwardButtonTapped), for: .touchUpInside)
        view.addSubview(backwardButton)
        backwardButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureShareButton() {
        shareButton.setImage(UIImage(named: "Sharing"), for: .normal)
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        view.addSubview(shareButton)
        shareButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backwardButton.widthAnchor.constraint(equalToConstant: 44),
            backwardButton.heightAnchor.constraint(equalToConstant: 44),
            backwardButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backwardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func backwardButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func didTapShareButton(_ sender: Any) {
        guard let image else {return}
        let viewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(viewController, animated: true)
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

let parallaxFactor: CGFloat = 0.5

// Height of the header image
let kUTCSParallaxBlurHeaderHeight: CGFloat = 284.0

// Height of the pseudo navigation bar of this view
let kUTCSParallaxBlurNavigationBarHeight: CGFloat = 44.0

// Modifier for the rate at which the background image view's alpha changes
let blurAlphaModifier: CGFloat = 2.5

// Content offset property string used for KVO
let contentOffsetPropertyString = "contentOffset"

// Frame property string used for KVO
let framePropertyString = "frame"


class ParallaxBlurHeaderScrollView: UIView {
    var headerMask: CAShapeLayer!
    var scrollView: UIScrollView!
    var headerImageContainer: UIVisualEffectView!
    var headerImageView: UIImageView!
    var headerContainerView: UIView!
    var headerImage: UIImage! {
        didSet(newValue){
            if newValue == headerImage {
                return
            } else {
                headerImage = newValue
            }
            headerImageView.image = headerImage
            layoutIfNeeded()
        }
    }

    override var frame: CGRect {
        didSet(newValue){
            super.frame = frame
            scrollView.frame = bounds
            layoutIfNeeded()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        headerMask = CAShapeLayer()
        headerImageContainer = {
            UIVisualEffectView(effect: UIBlurEffect(style: .Light))
        }()
        headerImageView = {
            let imageView = UIImageView()
            imageView.contentMode = .ScaleAspectFill
            imageView.userInteractionEnabled = false
            return imageView
        }()
        headerContainerView = {
            let view = UIView()
            view.addObserver(self, forKeyPath: framePropertyString, options: .New, context: nil)
            view.userInteractionEnabled = false
            view.layer.masksToBounds = true
            return view
        }()
        scrollView = {
            let scroll = UIScrollView(frame: self.bounds)
            scroll.addObserver(self, forKeyPath: contentOffsetPropertyString, options: .New, context: nil)
            scrollView.alwaysBounceVertical = true
            return scroll
        }()
        headerContainerView.addSubview(headerImageView)
        addSubview(headerContainerView)
        addSubview(scrollView)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutIfNeeded() {
        super.layoutSubviews()
        headerContainerView.frame = CGRect(x: 0.0, y: -parallaxFactor * scrollView.contentOffset.y, width: CGRectGetWidth(bounds), height: kUTCSParallaxBlurHeaderHeight)
        headerImageView.frame = headerContainerView.bounds
    }
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [NSObject : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath! == contentOffsetPropertyString && object as? UIScrollView == scrollView {
            let contentOffset = scrollView.contentOffset.y
            if contentOffset >= 0.0 && contentOffset < CGRectGetHeight(headerContainerView.bounds) - kUTCSParallaxBlurNavigationBarHeight {
                headerContainerView.frame = {
                    var frame = headerContainerView.frame
                    frame.origin.y = -parallaxFactor * contentOffset
                    return frame
                }()
                bringSubviewToFront(scrollView)
            } else {
                bringSubviewToFront(headerContainerView)
            }

            if contentOffset >= CGRectGetHeight(headerContainerView.bounds) - kUTCSParallaxBlurNavigationBarHeight {
                headerMask.path = UIBezierPath(rect: CGRect(x: 0.0, y: -headerContainerView.frame.origin.y, width: CGRectGetWidth(scrollView.bounds), height: kUTCSParallaxBlurNavigationBarHeight)).CGPath
                headerContainerView.layer.mask = headerMask
            } else {
                headerContainerView.layer.mask = nil
            }

            // SET THE BLUR RADIUS HERE

            for subview in headerContainerView.subviews {
                if subview != headerImageView {
                    subview.alpha = max(0.0, 1.0 - self.headerImageView.alpha)
                }
            }

        } else if keyPath == framePropertyString && object as? UIView == headerContainerView {
            if headerContainerView.frame.origin.y > 0.0 {
                headerContainerView.frame = {
                    var frame = headerContainerView.frame
                    frame.origin.y = 0.0
                    return frame
                }()
            }
        }
    }
    deinit{
        headerContainerView.removeObserver(self, forKeyPath: framePropertyString)
        scrollView.removeObserver(self, forKeyPath: contentOffsetPropertyString)
    }
}

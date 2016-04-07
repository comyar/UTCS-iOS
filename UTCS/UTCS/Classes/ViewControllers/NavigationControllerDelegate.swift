@objc public class NavigationControllerDelegate: NSObject, UINavigationControllerDelegate {
   
    var panGestureRecognizer: UIPanGestureRecognizer!
    var interactionController: UIPercentDrivenInteractiveTransition?

    var navigationController: NavigationController? {
        willSet(newValue){
            self.navigationController?.view.removeGestureRecognizer(panGestureRecognizer)
            self.navigationController = newValue
            self.navigationController?.view.addGestureRecognizer(panGestureRecognizer)
        }
    }

    override init(){
        super.init()
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didRecognizePanGesture(_:)))
    }
    
    public func didRecognizePanGesture(recognizer: UIPanGestureRecognizer) {
        if recognizer != panGestureRecognizer {
            return
        }
        let view = navigationController!.view
        switch recognizer.state {
        case .Began:
            let location = recognizer.locationInView(view)
            if location.x < CGRectGetMidX(view.bounds) {
                interactionController = UIPercentDrivenInteractiveTransition()
                navigationController?.popViewControllerAnimated(true)
            }
        case .Changed:
            let translation = recognizer.translationInView(view)
            let d = fabs(translation.x / CGRectGetWidth(view.bounds))
            interactionController?.updateInteractiveTransition(d)
        case .Ended:
            if recognizer.velocityInView(view).x > 0 {
                interactionController?.finishInteractiveTransition()
            } else {
                interactionController?.cancelInteractiveTransition()
            }
            interactionController = nil
        default:
            print("Unknown state")
        }
    }

    public func navigationController(navigationController: UINavigationController,
        interactionControllerForAnimationController
        animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
}

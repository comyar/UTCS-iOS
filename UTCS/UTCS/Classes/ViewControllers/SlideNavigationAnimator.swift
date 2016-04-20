import UIKit

class SlideNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var pushing = true
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        let containerView = transitionContext.containerView()!
        let viewSize = containerView.bounds.size
        
        containerView.addSubview(toController.view)

        let directionMultiplier: CGFloat = pushing ? 1 : -1
        let toStartOrigin = CGPoint(x: directionMultiplier * viewSize.width, y: 0.0)
        let toStartFrame = CGRect(origin: toStartOrigin, size: viewSize)
        let toDestinationFrame = fromController.view.frame

        let fromDestinationOrigin = CGPoint(x: -1.0 * directionMultiplier * viewSize.width , y: 0.0)
        let fromDestinationFrame = CGRect(origin: fromDestinationOrigin, size: viewSize)

        let duration = transitionDuration(transitionContext)

        toController.view.frame = toStartFrame
        
        UIView.animateWithDuration(duration, delay: 0, options: .CurveEaseInOut, animations: {
            fromController.view.frame = fromDestinationFrame
            fromController.view.alpha = 0.0
            
            toController.view.frame = toDestinationFrame
            toController.view.alpha = 1.0
            
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
}

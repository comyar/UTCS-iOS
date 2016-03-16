class SlideNavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    var pushing = true
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let toController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        let fromController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)

        transitionContext.containerView()?.addSubview(toController!.view)
        let viewSize = transitionContext.containerView()!.bounds.size

        let directionMultiplier: CGFloat = pushing ? 1.3 : -1.3
        let toStartOrigin = CGPoint(x: directionMultiplier * viewSize.width, y: 0.0)
        let toStartFrame = CGRect(origin: toStartOrigin, size: viewSize)
        let toDestinationFrame = fromController!.view.frame

        let fromDestinationOrigin = CGPoint(x: -1.0 * directionMultiplier * viewSize.width , y: 0.0)
        let fromDestinationFrame = CGRect(origin: fromDestinationOrigin, size: viewSize)

        let duration = transitionDuration(transitionContext)

        toController!.view.frame = toStartFrame
        UIView.animateWithDuration(duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            toController?.view.frame = toDestinationFrame
            toController?.view.alpha = 1.0

            fromController?.view.frame = fromDestinationFrame
            fromController?.view.alpha = 0.0
            }) { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }

    }
}
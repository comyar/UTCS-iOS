import pop

extension UIButton {
    class func bouncyButton() -> UIButton {
        let button = UIButton(type: .Custom)
        button.addTarget(button, action: #selector(UIView.bounceDown), forControlEvents: .TouchDown)
        let resetTriggers = [UIControlEvents.TouchCancel, .TouchDragExit, .TouchDragOutside, .TouchUpInside, .TouchUpOutside]
        for trigger in resetTriggers {
            button.addTarget(button, action: #selector(UIView.reset), forControlEvents: trigger)
        }
        return button
    }

    func menuNotification() {
        NSNotificationCenter.defaultCenter().postNotificationName(VerticalMenuDisplayNotification, object: nil)
    }

}
extension UIBarButtonItem {
    class func menuButton() -> UIBarButtonItem {
        let button = UIButton.bouncyButton()
        button.tag = NSIntegerMax
        button.frame = CGRect(x: 0.0, y: 0.0, width: 44.0, height: 44.0)
        button.addTarget(button, action: #selector(UIButton.menuNotification), forControlEvents: .TouchUpInside)
        let image = UIImage(named: "menu")
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0.0, y: 0.0, width: image!.size.width, height: image!.size.height)
        imageView.center = CGPoint(x: 0.5 * button.bounds.width, y: 0.5 * button.bounds.height)
        button.addSubview(imageView)
        return UIBarButtonItem(customView: button)
    }
}
protocol BouncyButton {
    func bounceTo(scale: CGFloat, alpha: CGFloat)
    func reset()
    func bounceDown()
}

extension UIView: BouncyButton {
    func bounceDown() {
        bounceTo(0.9, alpha: 0.5)
    }
    func bounceTo(scale: CGFloat, alpha: CGFloat) {
        var springAnimation = pop_animationForKey("bounce") as! POPSpringAnimation?
        var alphaAnimation = pop_animationForKey("alpha") as! POPBasicAnimation?
        let scaleValue = NSValue(CGPoint: CGPoint(x: scale, y: scale))
        if let springAnimation = springAnimation {
            springAnimation.toValue = scaleValue
        } else {
            springAnimation = POPSpringAnimation()
            springAnimation!.property = POPAnimatableProperty.propertyWithName(kPOPViewScaleXY) as! POPAnimatableProperty!
            springAnimation!.springBounciness = 20.0
            springAnimation!.springSpeed = 20.0
            springAnimation!.toValue = scaleValue
            pop_addAnimation(springAnimation, forKey: "bounce")
        }

        if let alphaAnimation = alphaAnimation {
            alphaAnimation.toValue = alpha
        } else {
            alphaAnimation = POPBasicAnimation()
            alphaAnimation?.property = POPAnimatableProperty.propertyWithName(kPOPViewAlpha) as! POPAnimatableProperty
            alphaAnimation?.toValue = alpha
            pop_addAnimation(alphaAnimation, forKey: "alpha")
        }

    }
    func reset() {
        bounceTo(1.0, alpha: 1.0)
    }
}

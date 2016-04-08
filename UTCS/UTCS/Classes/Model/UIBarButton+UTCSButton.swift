extension UIButton {
    
    static func bouncyButton() -> UIButton {
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
    
    static func menuButton() -> UIBarButtonItem {
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
    func reset()
    func bounceDown()
}

extension UIView: BouncyButton {
    
    func bounceDown() {
        bounceToScale(0.9)
    }
    
    private func bounceToScale(scale: CGFloat) {
        UIView.animateWithDuration(0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.transform = CGAffineTransformMakeScale(scale, scale)
            }, completion: nil)
    }

    func reset() {
        bounceToScale(1)
    }
    
}

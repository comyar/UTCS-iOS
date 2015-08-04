import Foundation
import pop

// Final scale of the content view when bouncing downwards
let bounceDownScale = 0.925;

// Final alpha of the content view when bouncing downwards
let bounceDownAlpha: CGFloat = 0.5;

// Bounciness of the POPSpringAnimation
let springBounciness: CGFloat = 20.0;

// Speed of the POPSpringAnimation
let springSpeed: CGFloat = 20.0;

// Key to identify the alpha animation
let alphaAnimationKey = "alpha";

// Key to identify the bounce animation
let bounceAnimationKey  = "bounce";

enum UTCSBouncyTableViewCellBounceDirection: Int {
    case Down, Up
}


class BouncyTableViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.textLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        self.detailTextLabel?.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        self.detailTextLabel?.textColor  = UIColor(white:1.0, alpha:0.5)
        self.selectionStyle = .None
        self.backgroundColor = UIColor.clearColor()
        self.textLabel?.textColor = UIColor.whiteColor()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        if highlighted && animated {
            self.bounceWithDirection(.Down)
        } else if !highlighted && animated {
            self.bounceWithDirection(.Up)
        }
    }
    func bounceWithDirection(direction: UTCSBouncyTableViewCellBounceDirection){
        var scaleValue = NSValue(CGPoint: CGPoint(x: 1.0, y: 1.0))
        let isDown = direction == .Down
        if isDown {
            scaleValue = NSValue(CGPoint: CGPoint(x: bounceDownScale, y: bounceDownScale))
        }
        let alphaValue = isDown ? bounceDownAlpha: 1.0
        var springAnimation = self.contentView.pop_animationForKey(bounceAnimationKey) as? POPSpringAnimation
        var alphaAnimation = self.contentView.pop_animationForKey(alphaAnimationKey) as? POPBasicAnimation

        if alphaAnimation != nil {
            alphaAnimation!.toValue = alphaValue
        } else {
            alphaAnimation = POPBasicAnimation()
            alphaAnimation!.property = POPAnimatableProperty.propertyWithName(kPOPViewAlpha) as! POPAnimatableProperty!
            alphaAnimation!.toValue = alphaValue
            self.contentView.pop_addAnimation(alphaAnimation, forKey: alphaAnimationKey)
        }

        if springAnimation != nil {
            springAnimation!.toValue = scaleValue
        } else {
            springAnimation = POPSpringAnimation()
            springAnimation!.property = POPAnimatableProperty.propertyWithName(kPOPViewScaleXY) as! POPAnimatableProperty
            springAnimation!.springBounciness = springBounciness
            springAnimation!.springSpeed = springSpeed
            springAnimation!.toValue = scaleValue
        }

    }
}
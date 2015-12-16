// Width of the stripe layer
let typeStripeWidth: CGFloat = 2.0;


class EventTableViewCell: BouncyTableViewCell {
    var typeStripeLayer = CAShapeLayer()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
        let stripe = CAShapeLayer()
        stripe.path = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: typeStripeWidth, height: CGRectGetHeight(self.bounds))).CGPath
        stripe.fillColor = UIColor.whiteColor().CGColor
        stripe.strokeStart = 0.0
        stripe.strokeEnd = 1.0
        self.typeStripeLayer = stripe
        self.layer.addSublayer(self.typeStripeLayer)
        backgroundColor = UIColor.clearColor()

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.typeStripeLayer.path = UIBezierPath(rect: CGRect(x: 0.0, y: 0.0, width: typeStripeWidth, height: CGRectGetHeight(self.bounds))).CGPath
    }
}


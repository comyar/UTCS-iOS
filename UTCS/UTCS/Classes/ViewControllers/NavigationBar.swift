import Foundation
import UIKit

class NavigationBar: UINavigationBar {
    let background = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(background)
        backgroundColor = UIColor.clearColor()
        background.backgroundColor = UIColor(white: 0.2, alpha: 0.85)
        background.userInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        background.frame = frame
        backgroundColor = UIColor.clearColor()
        sendSubviewToBack(background)
    }
}

import Foundation
import UIKit

class MenuTableViewCell: UITableViewCell {
    let selectedColor = UIColor.whiteColor()
    let highlightedColor = UIColor(white: 1.0, alpha: 0.7)
    let defaultColor = UIColor(white: 1.0, alpha: 0.5)
    
    override var selected: Bool {
        didSet {
            updateColors()
            updateImage()
        }
    }
    
    override var highlighted: Bool {
        didSet {
            updateColors()
        }
    }
    
    var menuType: MenuOption = .News {
        didSet {
            updateImage()
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .None
        backgroundColor = UIColor.clearColor()
        textLabel?.font = UIFont.systemFontOfSize(28.0)
        
        updateImage()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateColors() {
        var color = defaultColor
        
        if selected {
            color = selectedColor
        }
        
        if highlighted {
            color = highlightedColor
        }
        
        textLabel?.textColor =  color
        imageView?.tintColor = color
    }
    
    private func updateImage() {
        var imageName = menuType.title().lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "")
        if selected {
            imageName = "\(imageName)-active"
        }
        imageView?.image = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysTemplate)
    }
}

import UIKit

func RGB(value: Int) -> CGFloat {
    return CGFloat(value) / 255.0
}

extension UIColor {
    private static func with(r r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: RGB(r), green: RGB(g), blue: RGB(b), alpha: 1.0)
    }
    class func utcsBurntOrange() -> UIColor {
        return .with(r: 203, g: 96, b: 21)
    }

    class func utcsYellow() -> UIColor {
        return .with(r: 242, g: 169, b: 0)
    }

    class func utcsDarkGray() -> UIColor {
        return .with(r: 51, g: 51, b: 51)
    }

    class func utcsRed() -> UIColor {
        return .with(r: 204, g: 0, b: 17)
    }

    class func utcsGray() -> UIColor {
        return .with(r: 102, g: 102, b: 102)
    }

    class func utcsLightGray() -> UIColor {
        return .with(r: 153, g: 153, b: 153)
    }

    class func utcsCellHighlight() -> UIColor {
        return UIColor.grayColor().colorWithAlphaComponent(0.5)
    }

    class func utcsTableViewSeparator() -> UIColor {
        return .with(r: 225, g: 225, b: 225)
    }

    class func utcsTableViewHeader() -> UIColor {
        return .with(r: 210, g: 210, b: 210)
    }

    class func utcsRefreshControl() -> UIColor {
        return .with(r: 200, g: 200, b: 200)
    }

    class func utcsBarTint() -> UIColor {
        return UIColor(white: 0.2, alpha: 0.85)
    }

    class func utcsImageTint() -> UIColor {
        return UIColor(white: 0.11, alpha: 0.5)
    }

    class func utcsEventCareers() -> UIColor {
        return .with(r: 46, g: 204, b: 113)
    }

    class func utcsEventTalk() -> UIColor {
        return .with(r: 52, g: 153, b: 219)
    }

    class func utcsEventStudentOrgs() -> UIColor {
        return .with(r: 231, g: 76, b: 60)
    }
}
import UIKit

func RGB(value: Int) -> CGFloat {
    return CGFloat(value) / 255.0
}

extension UIColor {
    class func utcsBurntOrangeColor() -> UIColor {
        return UIColor(red: RGB(203), green: RGB(96), blue: RGB(21), alpha: 1.0)
    }

    class func utcsYellowColor() -> UIColor {
        return UIColor(red: RGB(242), green: RGB(169), blue: RGB(0), alpha: 1.0)
    }

    class func utcsDarkGrayColor() -> UIColor {
        return UIColor(red: RGB(51), green: RGB(51), blue: RGB(51), alpha: 1.0)
    }

    class func utcsRedColor() -> UIColor {
        return UIColor(red: RGB(204), green: RGB(0), blue: RGB(17), alpha: 1.0)
    }

    class func utcsGrayColor() -> UIColor {
        return UIColor(red: RGB(102), green: RGB(102), blue: RGB(102), alpha: 1.0)
    }

    class func utcsLightGrayColor() -> UIColor {
        return UIColor(red: RGB(153), green: RGB(153), blue: RGB(153), alpha: 1.0)
    }
    class func utcsTableViewSeparatorColor() -> UIColor {
        return UIColor(red: RGB(225), green: RGB(225), blue: RGB(225), alpha: 1.0)
    }

    class func utcsTableViewHeaderColor() -> UIColor {
        return UIColor(red: RGB(210), green: RGB(210), blue: RGB(210), alpha: 1.0)
    }

    class func utcsRefreshControlColor() -> UIColor {
        return UIColor(red: RGB(200), green: RGB(200), blue: RGB(200), alpha: 1.0)
    }

    class func utcsBarTintColor() -> UIColor {
        return UIColor(white: 0.2, alpha: 0.85)
    }

    class func utcsImageTintColor() -> UIColor {
        return UIColor(white: 0.11, alpha: 0.5)
    }

    class func utcsCalendarColor() -> UIColor {
        return UIColor(red: RGB(220), green: RGB(57), blue: RGB(38), alpha: 1.0)
    }

    class func utcsEventCareersColor() -> UIColor {
        return UIColor(red: RGB(46), green: RGB(204), blue: RGB(113), alpha: 1.0)
    }

    class func utcsEventTalkColor() -> UIColor {
        return UIColor(red: RGB(52), green: RGB(153), blue: RGB(219), alpha: 1.0)
    }

    class func utcsEventStudentOrgsColor() -> UIColor {
        return UIColor(red: RGB(231), green: RGB(76), blue: RGB(60), alpha: 1.0)
    }
}
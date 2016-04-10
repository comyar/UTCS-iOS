
import Foundation
import UIKit

extension UITableViewCell {
    func setSelectedBackgroundColor(color: UIColor) {
        let selectionView = UIView()
        selectionView.backgroundColor = color
        selectedBackgroundView = selectionView
    }
}

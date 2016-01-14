import Foundation
import UIKit

class AboutViewController: TableViewController {
    enum Section: Int {
        case About
        case Contributors
        case Version

        static let allValues = [Section.About, .Contributors, .Version]
    }

    private let contributors = ["Testing Test", "Jimmy Dean Breakfast Bowls"]

    init() {
        super.init(style: .Grouped)
        title = "About"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- UITableViewDataSource

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        if section == .Contributors {
            return contributors.count
        } else {
            return 1
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.allValues.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.text = "The UTCS app was developed by Comyar Zaheri under the direction of the" +
            "Department of Computer Science. The app is updated and maintained by Mobile App Development" +
            "(MAD), a student organization in the Department of Computer Science at the University of" +
        "Texas at Austin."
        return cell
    }
}
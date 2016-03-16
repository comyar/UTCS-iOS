import Foundation
import UIKit

class SettingsDataSource: NSObject, UITableViewDataSource {
    enum Section: Int {
        case Settings
        case Info
        case Social

        var title: String {
            switch self {
            case .Settings:
                return ""
            case .Info:
                return "Info"
            case .Social:
                return "Social"
            }
        }

        var rows: Int {
            switch self {
            case .Settings:
                return 2
            case .Info:
                return 1
            case .Social:
                return 2
            }
        }
        static let allValues = [Section.Settings, .Info, .Social]

    }
    

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return Section.allValues.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsDataSource.Section(rawValue: section) else {
            return 0
        }
        return section.rows
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let section = SettingsDataSource.Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        case .Social:
            let cell = tableView.dequeueReusableCellWithIdentifier("settings", forIndexPath: indexPath)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Facebook"
                cell.imageView?.image = UIImage(named: "facebook")?.imageWithRenderingMode(.AlwaysTemplate)
            } else {
                cell.textLabel?.text = "Twitter"
                cell.imageView?.image = UIImage(named: "twitter")?.imageWithRenderingMode(.AlwaysTemplate)
            }
            return cell
        case .Info:
            let cell = tableView.dequeueReusableCellWithIdentifier("settings", forIndexPath: indexPath)
            cell.textLabel?.text = "About"
            cell.accessoryType = .DisclosureIndicator
            return cell
        case .Settings:
            if indexPath.row == 0 {
                guard let cell =
                    tableView.dequeueReusableCellWithIdentifier("switch", forIndexPath: indexPath)
                        as? SwitchTableViewCell else {
                            return UITableViewCell()
                }
                cell.textLabel?.text = "Event Notifications"
                cell.detailTextLabel?.text = "Get notifications an hour before the start of starred events"
                return cell
            } else {
                guard let cell =
                    tableView.dequeueReusableCellWithIdentifier("segmented", forIndexPath: indexPath)
                        as? SegmentedControlTableViewCell else {
                        return UITableViewCell()
                }

                cell.textLabel?.text = "Preferred Lab"
                cell.segmentedControl.removeAllSegments()
                cell.segmentedControl.insertSegmentWithTitle("Third Floor", atIndex: 0, animated: false)
                cell.segmentedControl.insertSegmentWithTitle("Basement", atIndex: 1, animated: false)

                return cell
            }
        }
    }
}
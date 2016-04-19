import UIKit
import Foundation
final class DirectoryDataSource: ServiceDataSource, UITableViewDataSource {
    // Directory table view cell identifier.
    private let cellIdentifier = "UTCSDirectoryTableViewCell"
    var directoryPeople: [DirectoryPerson]! {
        return data as? [DirectoryPerson] ?? [DirectoryPerson]()
    }
    var directoryPeopleSections: [[DirectoryPerson]]?
    var filtered: [DirectoryPerson]!
    override var router: Router {
        return Router.Directory()
    }

    init() {
        super.init(service: .Directory, parser: DirectoryDataSourceParser())
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("directory") as? DirectoryTableViewCell,
            person = directoryPeopleSections?[indexPath.section][indexPath.row] else {
            return UITableViewCell()
        }

        cell.configure(person)
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return directoryPeopleSections?[section].count ?? 0
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return directoryPeopleSections?.count ?? 0
    }

    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        guard directoryPeopleSections != nil else {
            return nil
        }
        var letters = [String]()
        for section in directoryPeopleSections! {
            let asString = section[0].lastName as NSString
            letters.append(asString.substringToIndex(1))
        }
        return letters
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let person = directoryPeopleSections?[section][0] else {
            return ""
        }

        let lastName = person.lastName as NSString
        let letter = lastName.substringWithRange(NSRange(location: 0, length: 1))
        return letter
    }

}

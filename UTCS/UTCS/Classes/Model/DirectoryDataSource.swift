
// Directory table view cell identifier.
let UTCSDirectoryTableViewCellIdentifier = "UTCSDirectoryTableViewCell"


final class DirectoryDataSource: DataSource, UITableViewDataSource {
    var directoryPeople: [DirectoryPerson]! {
        get{
            return data as! [DirectoryPerson]
        }
    }
    var directoryPeopleSections: [[DirectoryPerson]]?
    var filtered: [DirectoryPerson]!
    var searchController: UISearchController!
    override var router: Router {
        get{
            return Router.Directory()
        }
    }

    init() {
        super.init(service: .Directory, parser: DirectoryDataSourceParser())
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCellWithIdentifier(UTCSDirectoryTableViewCellIdentifier)
        let cell = BouncyTableViewCell(style: .Subtitle, reuseIdentifier: UTCSDirectoryTableViewCellIdentifier)
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.selectionStyle = .None
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        let person: DirectoryPerson
        if searchController.active {
            person = filtered[indexPath.row]
        } else {
            person = directoryPeopleSections![indexPath.section][indexPath.row]
        }
        let attributedName = NSMutableAttributedString(string: person.fullName)
        attributedName.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(cell.textLabel!.font.pointSize, weight: 700.0), range: NSMakeRange(0, person.firstName.characters.count))
        attributedName.addAttribute(NSFontAttributeName, value: UIFont.systemFontOfSize(cell.textLabel!.font.pointSize, weight: 400.0), range: NSRange(location: person.firstName.characters.count + 1, length: person.lastName.characters.count))
        cell.indentationLevel = 1
        cell.textLabel?.attributedText = attributedName
        cell.detailTextLabel?.text = person.type

        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchController.active ? filtered.count : directoryPeopleSections?[section].count ?? 0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return searchController.active ? 1 : directoryPeopleSections?.count ?? 0
    }
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        guard searchController.active || directoryPeopleSections != nil else {
            return nil
        }
        var letters = [String]()
        for section in directoryPeopleSections! {
            let asString = section[0].lastName as NSString
            letters.append(asString.substringToIndex(1))
        }
        return letters
    }

}

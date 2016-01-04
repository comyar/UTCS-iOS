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
        //let cell = tableView.dequeueReusableCellWithIdentifier(UTCSDirectoryTableViewCellIdentifier)
        let cell = BouncyTableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.selectionStyle = .None
        cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
        let person = directoryPeopleSections![indexPath.section][indexPath.row]

        let attributedName = NSMutableAttributedString(string: person.fullName)

        let firstNameLength = person.firstName.characters.count
        let firstNameRange = NSRange(location: 0, length: firstNameLength)
        let remainingRange = NSRange(location: firstNameLength + 1, length: person.fullName.characters.count - 1 - firstNameLength)

        let firstNameWeight = UIFont.systemFontOfSize(cell.textLabel!.font.pointSize, weight: UIFontWeightBold)
        let remainingWeight = UIFont.systemFontOfSize(cell.textLabel!.font.pointSize, weight: UIFontWeightLight)
        attributedName.addAttribute(NSFontAttributeName, value: firstNameWeight, range: firstNameRange)
        attributedName.addAttribute(NSFontAttributeName, value: remainingWeight, range: remainingRange)
        cell.indentationLevel = 1
        cell.textLabel?.attributedText = attributedName
        cell.detailTextLabel?.text = person.type

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

}

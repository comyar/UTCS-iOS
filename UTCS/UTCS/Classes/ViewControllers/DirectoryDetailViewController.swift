import AlamofireImage

class DirectoryDetailViewController: TableViewController {
    let cellIdentifier = "UTCSDirectoryDetailTableViewCell"

    enum Section: Int {
        case Head, Information
    }
    enum InformationRow: Int {
        case Office, Homepage, Phone, ResearchInterests
    }
    var person: DirectoryPerson? {
        didSet(newValue) {
            tableView.reloadData()
        }
    }

    init() {
        super.init(style: .Grouped)
        needsSectionHeaders = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        tableView.registerClass(DirectoryDetailTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarBackgroundVisible = false
    }

    func formattedPhoneNumberWithString(phoneNumber: String) -> (String) {
        if phoneNumber.characters.count == 10 {
            let asNS = phoneNumber as NSString
            return String(format: "(%@) %@ - %@", arguments:
                [asNS.substringWithRange(NSRange(location: 0, length: 3)),
            asNS.substringWithRange(NSRange(location: 0, length: 3)),
                asNS.substringWithRange(NSRange(location: 3, length: 3)),
                asNS.substringWithRange(NSRange(location: 6, length: 4))])
        }
        return phoneNumber
    }

    func didTouchUpInsideButton(button: UIButton) {
        if button.tag == Int.min,
           let number = self.person?.phoneNumber {
            let controller = UIAlertController(title: "Confirm", message: "Are you sure you want to call?", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            controller.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (_) -> Void in
                self.callNumber(number)
            }))
            presentViewController(controller, animated: true, completion: nil)
        }
    }

    func callNumber(number: String) {
        let phoneURL = NSURL(string: "telprompt:\(number)")!
        if UIApplication.sharedApplication().canOpenURL(phoneURL) {
            UIApplication.sharedApplication().openURL(phoneURL)
        } else {
            let controller = UIAlertController(title: "Error", message: "Ouch! Looks like something went wrong. Please report a bug!", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Meh, Okay", style: .Default, handler: { (UIAlertAction) -> Void in
                controller.dismissViewControllerAnimated(true, completion: nil)
            }))
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            as? DirectoryDetailTableViewCell,
            section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        if section == .Head {
            cell.textLabel?.text = person?.fullName
            cell.detailTextLabel?.text = person?.title

            if let url = person?.imageURL {
                cell.imageView?.frame = CGRect(x: 0, y: 0, width: 40.0, height: 40.0)
                let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: cell.imageView!.frame.size,
                    radius: 20.0
                )
                cell.imageView?.af_setImageWithURL(url, placeholderImage: UIImage(named: "directory-active"), filter: filter,
                                                   imageTransition: UIImageView.ImageTransition.CrossDissolve(0.20), runImageTransitionIfCached: false)

            }
        } else if section == .Information {
            guard let row = InformationRow(rawValue: indexPath.row) else {
                return cell
            }
            switch row {
            case .Office:
                guard let office = person?.office else {
                    return cell
                }
                cell.textLabel?.text = office
                cell.detailTextLabel?.text = "Office"
                cell.accessoryView?.hidden = true
                break
            case .Homepage:
                guard let homepage = person?.homepageURL else {
                    return cell
                }
                cell.textLabel?.text = homepage.absoluteString
                cell.textLabel?.adjustsFontSizeToFitWidth = true
                cell.textLabel?.numberOfLines = 1
                cell.detailTextLabel?.text = "Homepage"
                cell.accessoryType = .DisclosureIndicator
                cell.accessoryView?.hidden = false
                break
            case .Phone:
                guard let number = person?.phoneNumber else {
                    return cell
                }
                cell.textLabel?.text = formattedPhoneNumberWithString(number)
                cell.detailTextLabel?.text = "Phone"
                cell.accessoryView?.hidden = false
                break
            case .ResearchInterests:
                guard let interests = person?.researchInterests else {
                    return cell
                }
                var interestsString = interests.reduce(""){$0 + "; " + $1}
                interestsString = interestsString.substringFromIndex(interestsString.startIndex.advancedBy(2))
                cell.textLabel?.text = interestsString
                cell.detailTextLabel?.text = "Research Interests"
                cell.accessoryView?.hidden = true
                break

                }
        }

        return cell
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        if section == .Head {
            return 1
        } else if section == .Information {
            return 4
        }
        return 0
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Information"
        }
        return nil
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 84.0
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return person?.office != nil ? 64.0 : 0.0
            }  else if indexPath.row == 1 {
                return person?.homepageURL != nil ? 64.0 : 0.0
            } else if indexPath.row == 2 {
                return person?.phoneNumber != nil ? 64.0 : 0.0
            } else if indexPath.row == 3 {
                return person?.researchInterests != nil ? 64.0: 0.0
            }
        }
        return 0.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let section = Section(rawValue: indexPath.section) where section == .Information else {
            return
        }
        if let row = InformationRow(rawValue: indexPath.row),
           homepage = person?.homepageURL where row == .Homepage {
            UIApplication.sharedApplication().openURL(homepage)
        }
    }
}


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
        didSet {
            tableView.reloadData()
        }
    }

    init() {
        super.init(style: .Grouped)
        navigationBarBackgroundVisible = false
        needsSectionHeaders = true
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarBackgroundVisible = false
    }

    func formattedPhoneNumberWithString(phoneNumber: String) -> String {
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
            let errorAlertController = UIAlertController(title: "Error", message: "Oops! Something went wrong. Please report a bug!", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            errorAlertController.addAction(okAction)
            
            presentViewController(errorAlertController, animated: true, completion: nil)
        }
    }
    
    private func callButton() -> UIButton {
        let callButton = UIButton(type: .Custom)
        callButton.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 28.0)
        callButton.setTitle("Call", forState: .Normal)
        callButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        callButton.tintColor = UIColor.whiteColor()
        callButton.layer.masksToBounds = true
        callButton.layer.cornerRadius = 4.0
        callButton.layer.borderWidth = 1.0
        callButton.layer.borderColor = UIColor.whiteColor().CGColor
        callButton.addTarget(self, action: #selector(callPerson), forControlEvents: .TouchUpInside)
        return callButton
    }
    
    func callPerson() {
        if let number = person?.phoneNumber?.stringByReplacingOccurrencesOfString(" ", withString: "-") {
            callNumber(number)
        }
    }
    
    // MARK - UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tempCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        
        if tempCell == nil {
            tempCell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        guard let section = Section(rawValue: indexPath.section), cell = tempCell else {
            return UITableViewCell()
        }
        
        //Default cell styling
        cell.selectionStyle = .None
        cell.textLabel?.text = ""
        cell.detailTextLabel?.text = ""
        cell.accessoryView?.hidden = true
        cell.selectedBackgroundView = nil
        cell.accessoryView = nil
        cell.textLabel?.numberOfLines = 1
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)

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
                print(person?.office)
                break
            case .Homepage:
                guard person?.homepageURL != nil else {
                    return cell
                }
                cell.textLabel?.text = "Homepage"
                cell.accessoryType = .DisclosureIndicator
                cell.accessoryView?.hidden = false
                cell.selectionStyle = .Default
                cell.setSelectedBackgroundColor(UIColor.utcsCellHighlight())
                print(person?.homepageURL)
                break
            case .Phone:
                guard let number = person?.phoneNumber else {
                    return cell
                }
                cell.textLabel?.text = formattedPhoneNumberWithString(number)
                cell.detailTextLabel?.text = "Phone"
                if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel://")!) {
                    cell.accessoryView?.hidden = false
                    cell.accessoryView = callButton()
                }
                
                print(person?.phoneNumber)
                break
            case .ResearchInterests:
                guard let interests = person?.researchInterests else {
                    return cell
                }
                var interestsString = interests.reduce(""){$0 + "; " + $1}
                interestsString = interestsString.substringFromIndex(interestsString.startIndex.advancedBy(2))
                cell.textLabel?.text = interestsString
                cell.textLabel?.numberOfLines = 0
                cell.detailTextLabel?.text = "Research Interests"
                print(person?.researchInterests)
                break

                }
        }

        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        if section == .Head {
            return 1
        } else if section == .Information {
            return 4
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Information" : nil
    }

    // MARK: - UITableViewDelegate
    
    func cellLabelHeightForText(string: String) -> CGFloat {
        let text = NSString(string: string)
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: nil)
        
        if let inset = cell.textLabel?.frame.origin.x, font = cell.textLabel?.font {
            let frame = text.boundingRectWithSize(CGSize(width: UIScreen.mainScreen().bounds.width - inset * 2, height: 0),
                                                  options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                                                  attributes: [NSFontAttributeName : font],
                                                  context: nil)
            return frame.height
        }
        
        return 64.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            return 84
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return person?.office != nil ? 64.0 : 0.0
            }  else if indexPath.row == 1 {
                return person?.homepageURL != nil ? 64.0 : 0.0
            } else if indexPath.row == 2 {
                return person?.phoneNumber != nil ? 64.0 : 0.0
            } else if indexPath.row == 3 {
                if let interests = person?.researchInterests {
                    var interestsString = interests.reduce(""){$0 + "; " + $1}
                    interestsString = interestsString.substringFromIndex(interestsString.startIndex.advancedBy(2))
                    let size = cellLabelHeightForText(interestsString) + 30
                    return size > 64.0 ? size : 64.0
                }
                return 0.0
            }
        }
        
        
        
        return 0.0
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let section = Section(rawValue: indexPath.section), cell = tableView.cellForRowAtIndexPath(indexPath) where section == .Information else {
            return
        }
        
        cell.selected = false
        
        if let row = InformationRow(rawValue: indexPath.row),
           homepage = person?.homepageURL where row == .Homepage {
            UIApplication.sharedApplication().openURL(homepage)
        }
    }
    
}


import AlamofireImage

class DirectoryDetailViewController: TableViewController {

    let cellIdentifier = "UTCSDirectoryDetailTableViewCell"
    
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

    required convenience init(coder aDecoder: NSCoder) {
        self.init()
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
    
    func callPerson() {
        guard let phoneNumber = person?.phoneNumber?.stringByReplacingOccurrencesOfString(" ", withString: "-"),
            callURL = NSURL(string: "tel:\(phoneNumber)") else { return }
        
        if UIApplication.sharedApplication().canOpenURL(callURL) {
            let confirmationAlertController = UIAlertController(title: phoneNumber, message: nil, preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            confirmationAlertController.addAction(cancelAction)
            
            let callAction = UIAlertAction(title: "Call", style: .Default) { _ in
                UIApplication.sharedApplication().openURL(callURL)
            }
            confirmationAlertController.addAction(callAction)
            
            presentViewController(confirmationAlertController, animated: true, completion: nil)
        } else {
            let errorAlertController = UIAlertController(title: "Error", message: "Oops! Something went wrong. Please report a bug!", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            errorAlertController.addAction(okAction)
            
            presentViewController(errorAlertController, animated: true, completion: nil)
        }
    }
    
    // MARK - UITableViewDataSource
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var oldCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if oldCell == nil {
            let newCell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifier)
            newCell.textLabel?.textColor = UIColor(white: 1.0, alpha: 0.8)
            newCell.textLabel?.numberOfLines = 2
            newCell.detailTextLabel?.textColor = UIColor(white: 1.0, alpha: 0.5)
            newCell.imageView?.contentMode = .ScaleAspectFill
            newCell.imageView?.autoresizingMask = .None
            newCell.backgroundColor = UIColor.clearColor()
            newCell.selectionStyle = .None
            newCell.textLabel?.textAlignment = .Left
            
            let callButton = UIButton.bouncyButton()
            callButton.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 28.0)
            callButton.setTitle("Call", forState: .Normal)
            callButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            callButton.tintColor = UIColor.whiteColor()
            callButton.layer.masksToBounds = true
            callButton.layer.cornerRadius = 4.0
            callButton.layer.borderWidth = 1.0
            callButton.layer.borderColor = UIColor.whiteColor().CGColor
            callButton.addTarget(self, action: #selector(callPerson), forControlEvents: .TouchUpInside)
            
            newCell.accessoryView = callButton
            newCell.accessoryView?.hidden = true
            oldCell = newCell
        }
        if let cell = oldCell {

        if indexPath.section == 0 {
            cell.textLabel?.text = person?.fullName
            cell.detailTextLabel?.text = person?.title

            if let url = person?.imageURL {
                cell.imageView?.frame = CGRect(x: 0, y: 0, width: 40.0, height: 40.0)
                let filter = AspectScaledToFillSizeWithRoundedCornersFilter(
                    size: cell.imageView!.frame.size,
                    radius: 20.0
                )
                cell.imageView?.af_setImageWithURL(url, placeholderImage: nil, filter: filter,
                                                   imageTransition: UIImageView.ImageTransition.CrossDissolve(0.20), runImageTransitionIfCached: false)
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0,
               let office = person?.office {
                cell.textLabel?.text = office
                cell.detailTextLabel?.text = "Office"
            } else if indexPath.row == 1,
                    let number = person?.phoneNumber {
                cell.textLabel?.text = formattedPhoneNumberWithString(number)
                cell.detailTextLabel?.text = "Phone"
                cell.accessoryView?.hidden = false

            }

        }
        }
        return oldCell!
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 1 ? "Information" : nil
    }

    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath == NSIndexPath(forRow: 0, inSection: 0) {
            return 84
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return person?.office != nil ? 64 : 0
            } else {
                return person?.phoneNumber != nil ? 64 : 0
            }
        }
        return 50
    }
    
}

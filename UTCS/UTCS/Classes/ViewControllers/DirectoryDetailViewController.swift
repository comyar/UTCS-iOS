import AlamofireImage

class DirectoryDetailViewController: TableViewController {
    let cellIdentifier = "UTCSDirectoryDetailTableViewCell"
    var person: DirectoryPerson? {
        didSet(newValue) {
            tableView.reloadData()
        }
    }

    init() {
        super.init(style: .Grouped)
        needsSectionHeaders = true
        backgroundImageName = "Directory"
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationBarBackgroundVisible = false
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        let phoneURL = NSURL(string: "tel:\(number)")!
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
            callButton.tag = Int.min
            newCell.accessoryView = callButton
            newCell.accessoryView?.hidden = true
            oldCell = newCell
        }
        if let cell = oldCell {

        if indexPath.section == 0 {
            cell.textLabel?.text = person?.fullName
            cell.detailTextLabel?.text = person?.title

            if let url = person?.imageURL {
                cell.imageView?.af_setImageWithURL(url, placeholderImage: nil,
                    imageTransition: UIImageView.ImageTransition.CrossDissolve(0.20),
                    runImageTransitionIfCached: false)
                cell.imageView?.layer.cornerRadius = cell.imageView?.bounds.width ?? 0 / 2.0
                cell.imageView?.layer.masksToBounds = true
                cell.imageView?.contentMode = .ScaleAspectFill
                cell.setNeedsLayout()
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

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 2
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
            } else if indexPath.row == 1 {
                return person?.phoneNumber != nil ? 64.0 : 0.0
            }
        }
        return 50.0
    }
}



// Directory detail table view cell identifier.
let DirectoryDetailTableViewCellIdentifier = "UTCSDirectoryDetailTableViewCell";


class DirectoryDetailViewController: TableViewController {
    var person: UTCSDirectoryPerson? {
        didSet(newValue){
            tableView.reloadData()
        }
    }
    init(){
        super.init(style: .Grouped)
        commoninit()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func commoninit(){
        tableView.dataSource = self;
        tableView.separatorStyle = .None;
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        menuButton.hidden = true
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
    func didTouchUpInsideButton(button: UIButton){
        if button.tag == Int.min {
            let controller = UIAlertController(title: "Confirm", message: "Are you sure you want to call?", preferredStyle: .Alert)
            controller.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            controller.addAction(UIAlertAction(title: "Yes", style: .Default, handler: { (_) -> Void in
                self.callNumber()
            }))
            presentViewController(controller, animated: true, completion: nil)
        }
    }
    func callNumber(){
        let phoneNumber = self.person?.phoneNumber!
        let phoneURL = NSURL(string: "tel:\(phoneNumber)")!
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
        var cell = tableView.dequeueReusableCellWithIdentifier(DirectoryDetailTableViewCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: DirectoryDetailTableViewCellIdentifier)
            cell?.textLabel?.textColor = UIColor(white: 1.0, alpha: 0.8)
            cell?.textLabel?.numberOfLines = 2
            cell?.detailTextLabel?.textColor = UIColor(white: 1.0, alpha: 0.5)
            cell?.imageView?.contentMode = .ScaleAspectFill
            cell?.imageView?.autoresizingMask = .None
            cell?.backgroundColor = UIColor.clearColor()
            cell?.selectionStyle = .None
            cell?.textLabel?.textAlignment = .Left
            let callButton = UIButton.bouncyButton()

            callButton.frame = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 28.0)
            callButton.setTitle("Call", forState: .Normal)
            callButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            callButton.center = CGPoint(x: cell!.frame.width - callButton.frame.width, y: cell!.center.y)
            callButton.tintColor = UIColor.whiteColor()
            callButton.layer.masksToBounds = true
            callButton.layer.cornerRadius = 4.0
            callButton.layer.borderWidth = 1.0
            callButton.tag = Int.min
            cell?.contentView.addSubview(callButton)
        }
        let button = cell?.contentView.viewWithTag(Int.min) as! UIButton
        button.hidden = true
        if indexPath.section == 0 {
            cell?.textLabel?.text = person?.fullName
            cell?.detailTextLabel?.text = person?.type

            if person?.imageURL != nil {
                let url = NSURL(string: person!.imageURL)
                weak var weakCell = cell
                cell?.imageView?.setImageWithURLRequest(NSURLRequest(URL: url!), placeholderImage: nil, success: { (_, _, image) -> Void in
                    weakCell?.imageView?.image = image
                    weakCell?.imageView?.layer.cornerRadius = 32.0
                    weakCell?.imageView?.layer.masksToBounds = true
                    weakCell?.imageView?.contentMode = .ScaleAspectFill
                    weakCell?.setNeedsLayout()
                    }, failure: { (_, _, _) -> Void in
                        weakCell?.imageView?.image = nil
                })
            }
            cell?.imageView?.contentMode = .ScaleAspectFill
        } else if indexPath.section == 1  {
            if indexPath.row == 0 {
                var text = person?.office!
                var subtitle = "Office"
                text = text?.characters.count != 0 ? text : formattedPhoneNumberWithString((person?.phoneNumber)!)
                subtitle = text?.characters.count != 0 ? subtitle : "Phone"
                cell?.textLabel?.text = text
                cell?.detailTextLabel?.text = subtitle
            } else if indexPath == 1 {
                cell?.textLabel?.text = formattedPhoneNumberWithString((person?.phoneNumber)!)
                cell?.detailTextLabel?.text = "Phone"
            }

            if cell?.detailTextLabel?.text == "Phone" {
                button.hidden = false
            }
        }
        return cell!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            var count = 0
            if person?.office != nil {
                count++
            }
            if person?.phoneNumber != nil {
                count++
            }
            return count
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
        if indexPath.row == 0 && indexPath.section == 0 {
            return 64.0
        }
        return 50.0
    }
}

//
//  AutomaticDimensionTableViewController.swift
//  UTCS
//
//  Created by Jesse Tipton on 3/30/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import UIKit

class AutomaticDimensionTableViewController: UITableViewController {
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

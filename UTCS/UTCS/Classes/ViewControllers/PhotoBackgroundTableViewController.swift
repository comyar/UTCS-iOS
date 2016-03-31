//
//  PhotoBackgroundTableViewController.swift
//  UTCS
//
//  Created by Jesse Tipton on 3/30/16.
//  Copyright © 2016 UTCS. All rights reserved.
//

import UIKit

class PhotoBackgroundTableViewController: AutomaticDimensionTableViewController {

    var navigationBarBackgroundVisible = true {
        willSet(newValue) {
            if navigationBarBackgroundVisible {
                navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
            } else {
                navigationController?.navigationBar.backgroundColor = UIColor(white: 1, alpha: 0.4)
            }
        }
    }
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var backgroundImageName: String = "defaultBackground" {
        willSet(newValue) {
            backgroundImageView.image = UIImage(named: newValue)
        }
    }
    
    var showsNavigationBarSeparatorLine = true
    var needsSectionHeaders = false {
        didSet(oldValue) {
            tableView.reloadData()
        }
    }
    
    // MARK:- Initialization

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarBackgroundVisible = false
        extendedLayoutIncludesOpaqueBars = true
        tableView.separatorColor = .whiteColor()
        tableView.backgroundColor = .clearColor()
        tableView.sectionIndexColor = .whiteColor()
        tableView.sectionIndexBackgroundColor = .clearColor()
        tableView.tableHeaderView?.backgroundColor = .clearColor()
        tableView.cellLayoutMarginsFollowReadableWidth = true
        
        view.addSubview(backgroundImageView)
        tableView.addLayoutGuide(tableView.readableContentGuide)
        tableView.cellLayoutMarginsFollowReadableWidth = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.frame = view.bounds
        
        view.sendSubviewToBack(backgroundImageView)
    }
    
    // MARK:- UITableViewController
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard needsSectionHeaders else {
            return nil
        }
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(16.0)
        // Hack to get left margin
        label.text = "     " + (tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section) ?? "")
        label.textColor = UIColor(white: 1.0, alpha: 1.0)
        label.backgroundColor = UIColor(white: 0.5, alpha: 0.2)
        label.sizeToFit()
        return label
    }
    
    //Required for viewForHeaderInSection to be called
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return needsSectionHeaders ? 24.0 : 0.0
    }
    
}

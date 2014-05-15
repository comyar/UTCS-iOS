//
//  UTCSSettingsDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import Foundation;


#pragma mark - UTCSSettingsDataSource Interface

/**
 UTCSSettingsDataSource is the data source for the table view managed by UTCSSettingsViewController.
 */
@interface UTCSSettingsDataSource : NSObject <UITableViewDataSource>

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 Titles of the table view's sections.
 */
@property (nonatomic, readonly) NSArray *sectionTitles;

@end

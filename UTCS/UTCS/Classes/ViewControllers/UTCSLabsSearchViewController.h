//
//  UTCSLabsSearchViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSContentViewController.h"

#import "UTCSLabsDataSourceSearchController.h"

@interface UTCSLabsSearchViewController : UTCSContentViewController

@property (nonatomic, readonly) UTCSLabsDataSourceSearchController *searchController;

@end

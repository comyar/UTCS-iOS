//
//  UTCSDirectoryManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 */
typedef void (^UTCSDirectoryDataSourceCompletion) (NSDate *updated);


@interface UTCSDirectoryDataSource : NSObject <UITableViewDataSource>



/**
 */
- (void)updateDirectoryWithCompletion:(UTCSDirectoryDataSourceCompletion)completion;


- (NSArray *)searchDirectoryWithSearchString:(NSString *)searchString scope:(NSString *)scope;

@property (nonatomic, readonly) NSArray         *directory;
@property (nonatomic) UISearchDisplayController *searchDisplayController;

@end

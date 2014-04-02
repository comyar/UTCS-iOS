//
//  UTCSDirectoryManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTCSDirectoryManager : NSObject <UITableViewDataSource, UISearchDisplayDelegate>


- (void)syncDirectoryWithCompletion:(void (^)(BOOL success))completion;


@property (nonatomic, readonly) NSArray         *directory;
@property (nonatomic) UISearchDisplayController *searchDisplayController;

@end

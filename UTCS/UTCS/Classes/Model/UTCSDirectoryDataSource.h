//
//  UTCSDirectoryManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDataSource.h"


@interface UTCSDirectoryDataSource : UTCSDataSource <UITableViewDataSource>

- (void)buildFlatDirectory;


@property (nonatomic, readonly) NSArray *flatDirectory;

@end
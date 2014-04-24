//
//  UTCSDataSourceSearchController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/24/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDataSourceSearchController.h"

@implementation UTCSDataSourceSearchController

- (void)searchWithQuery:(NSString *)query scope:(NSString *)scope completion:(UTCSDataSourceSearchCompletion)completion
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

@end

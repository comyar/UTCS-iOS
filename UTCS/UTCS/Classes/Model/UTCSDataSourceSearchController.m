//
//  UTCSDataSourceSearchController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDataSourceSearchController.h"

@implementation UTCSDataSourceSearchController

- (NSArray *)resultsForQuery:(NSString *)query
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selected %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

- (NSArray *)resultsForQuery:(NSString *)query withFilter:(NSString *)filter
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selected %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

@end

//
//  UTCSDataSourceSearchController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

/**
 UTCSDataSourceSearchController is an abstract class
 */
@interface UTCSDataSourceSearchController : NSObject

- (NSArray *)resultsForQuery:(NSString *)query;
- (NSArray *)resultsForQuery:(NSString *)query withFilter:(NSString *)filter;

@end

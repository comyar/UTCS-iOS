//
//  UTCSAbstractDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

#import "UTCSDataRequestServicer.h"



@class UTCSDataSourceCache;
@class UTCSDataSourceParser;
@class UTCSDataSourceSearchController;


/**
 */
typedef void (^UTCSDataSourceCompletion) (BOOL success);
typedef NSString UTCSServiceName;


@class UTCSDataSource;

@protocol UTCSDataSourceDelegate <NSObject>

- (NSDictionary *)objectsToCacheForDataSource:(UTCSDataSource *)dataSource;

@end

/**
 UTCSDataSource is an abstract class 
 */
@interface UTCSDataSource : NSObject <UISearchDisplayDelegate>

// -----
// @name Creating a UTCSAbstractDataSource
// -----

/**
 */
- (instancetype)initWithService:(NSString *)service;

// -----
// @name Using a UTCSAbstractDataSource
// -----

/**
 */
- (BOOL)shouldUpdate;

/**
 */
- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion;

// -----
// @name Property
// -----

/**
 */
@property (nonatomic) UTCSDataSourceParser              *parser;

/**
 */
@property (nonatomic) UTCSDataSourceCache               *cache;

/**
 */
@property (nonatomic) UTCSDataSourceSearchController    *searchController;

/**
 */
@property (nonatomic, readonly) NSString            *service;

/**
 */
@property (nonatomic, readonly) id                  data;

/**
 */
@property (nonatomic, readonly) NSDate              *updated;

/**
 */
@property (nonatomic) NSTimeInterval      minimumTimeBetweenUpdates;

/**
 */
@property (weak, nonatomic) id<UTCSDataSourceDelegate>    delegate;

@end

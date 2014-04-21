//
//  UTCSAbstractDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

#import "UTCSDataRequestServicer.h"

@class UTCSAbstractDataSourceCache;
@class UTCSAbstractDataSourceParser;

/**
 */
typedef void (^UTCSDataSourceCompletion) (BOOL success);
typedef NSString UTCSServiceName;

/**
 */
@interface UTCSAbstractDataSource : NSObject

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
@property (nonatomic) UTCSAbstractDataSourceParser  *dataSourceParser;

/**
 */
@property (nonatomic) UTCSAbstractDataSourceCache   *dataSourceCache;

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
@property (nonatomic, readonly) NSTimeInterval      minimumTimeBetweenUpdates;

@end

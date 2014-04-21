//
//  UTCSAbstractDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

#import "UTCSDataRequestServicer.h"

@class UTCSAbstractDataSourceParser;

/**
 */
typedef void (^UTCSDataSourceCompletion) (BOOL success);
typedef NSString UTCSServiceName;

/**
 */
@interface UTCSAbstractDataSource : NSObject

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
@property (nonatomic) UTCSServiceName               *service;

/**
 */
@property (nonatomic) UTCSDataRequestType           requestType;

/**
 */
@property (nonatomic) UTCSAbstractDataSourceParser *dataSourceParser;

/**
 */
@property (nonatomic, readonly) id                  data;

@end

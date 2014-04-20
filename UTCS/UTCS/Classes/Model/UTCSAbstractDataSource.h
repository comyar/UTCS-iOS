//
//  UTCSAbstractDataSource.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;
#import "UTCSDataRequestServicer.h"

/**
 */
typedef void (^UTCSDataSourceCompletion) (id values, NSError *error);


/**
 */
@interface UTCSAbstractDataSource : NSObject

/**
 */
- (BOOL)shouldUpdate;

/**
 */
- (void)updateWithCompletion:(UTCSDataSourceCompletion)completion;

// -----
// @name Property
// -----

/**
 */
@property (nonatomic) NSString              *service;

/**
 */
@property (nonatomic) UTCSDataRequestType   requestType;

@end

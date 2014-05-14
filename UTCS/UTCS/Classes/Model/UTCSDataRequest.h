//
//  UTCSDataRequestServicer.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import Foundation;
#import <AFNetworking/AFHTTPRequestOperation.h>


#pragma mark - Type Definitions

/**
 Data request completion handler block.
 @param meta    Meta data provided by the endpoint. nil if error.
 @param values  Values downloaded for the particular service. nil if error.
 @param error   Error, if one occurs.
 */
typedef void (^UTCSDataRequestCompletion)(NSDictionary *meta, id values, NSError *error);


#pragma mark - UTCSDataRequestServicer Interface

/**
 UTCSDataRequest provides an interface for requesting data from the app's backend endpoint. The class methods
 provided by UTCSDataRequest allow you to asynchronously request data for specific services.
 */
@interface UTCSDataRequest : NSObject

// -----
// @name Class Methods
// -----

#pragma mark Class Methods

/**
 Sends a data request to the app's backend endpoint.
 @param service     Name of the service requesting data. May not be nil.
 @param argument    Argument for the request. May be nil.
 @param completion  Completion handler block. May not be nil.
 */
+ (void)sendDataRequestForService:(NSString *)service
                         argument:(NSString *)argument
                       completion:(UTCSDataRequestCompletion)completion;

@end

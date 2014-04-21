//
//  UTCSDataRequestServicer.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

/**
 */
typedef void (^UTCSDataRequestServicerCompletion)(NSDictionary *meta, id values, NSError *error);


/**
 */
@interface UTCSDataRequestServicer : NSObject

+ (void)sendDataRequestForService:(NSString *)service
                         argument:(NSString *)argument
                       completion:(UTCSDataRequestServicerCompletion)completion;

@end

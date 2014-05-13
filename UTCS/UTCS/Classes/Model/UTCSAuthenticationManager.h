//
//  UTCSAuthenticationManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

typedef void (^UTCSAuthenticationCompletion) (BOOL success, NSError *error);

extern NSString * const UTCSAuthenticationErrorDomain;

typedef NS_ENUM(u_int16_t, UTCSAuthenticationErrorCode) {
    UTCSAuthenticationConnectionErrorCode   = -1,
    UTCSAuthenticationAccessDeniedErrorCode = -2
};


@interface UTCSAuthenticationManager : NSObject


+ (UTCSAuthenticationManager *)sharedManager;

- (void)authenticateUser:(NSString *)user withPassword:(NSString *)password completion:(UTCSAuthenticationCompletion)completion;

@property (nonatomic, readonly) BOOL authenticated;


@end

//
//  UTCSAuthenticationManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import Foundation;
#import <NMSSH/NMSSH.h>


#pragma mark - Constants

/**
 Error domain for errors returned by the authentication manager
 */
extern NSString * const UTCSAuthenticationErrorDomain;


#pragma mark - Type Definitions

/**
 Error codes for errors that may occur during authentication
 */
typedef NS_ENUM(int8_t, UTCSAuthenticationErrorCode) {
    /** Authentication failed due to network connection error */
    UTCSAuthenticationConnectionErrorCode   = -1,
    
    /** Authentication failed due to invalid credentials */
    UTCSAuthenticationAccessDeniedErrorCode = -2
};

/**
 Authentication completion handler block.
 @param success     YES if the user authenticated successfully.
 @param error       Error, if one occurred during authentication, nil otherwise.
 */
typedef void (^UTCSAuthenticationCompletion) (BOOL success, NSError *error);


#pragma mark - UTCSAuthenticationManager Interface

/**
 UTCSAuthenticationManager is a singleton class that provides an interface for authenticating a user.
 
 A user only needs to authenticate once. All subsequent attempts to authenticate the user will complete immediately
 and indicate success.
 */
@interface UTCSAuthenticationManager : NSObject

// -----
// @name Getting the Authentication Manager
// -----

#pragma mark Getting the Authentication Manager

/**
 Returns he shared authentication manager instance.
 @return The shared authentication manager instance.
 */
+ (UTCSAuthenticationManager *)sharedManager;

// -----
// @name Using the Authentication Manager
// -----

#pragma mark Using the Authentication Manager

/**
 */
- (void)authenticateUser:(NSString *)user withPassword:(NSString *)password completion:(UTCSAuthenticationCompletion)completion;

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 YES if the user has successfully authenticated.
 */
@property (nonatomic, readonly) BOOL authenticated;

@end

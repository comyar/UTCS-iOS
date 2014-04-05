//
//  UTCSSSHAuthHandler.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/2/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTCSSSHManager : NSObject

+ (UTCSSSHManager *)sharedSSHManager;

- (void)connectWithUsername:(NSString *)username password:(NSString *)password completion:(void(^)(BOOL success))completion;
- (void)executeCommand:(NSString *)command completion:(void (^)(NSString *response))completion;
- (void)disconnect;

@property (nonatomic, readonly, getter = isConnected)       BOOL connected;
@property (nonatomic, readonly, getter = isAuthenticated)   BOOL authenticated;

@end

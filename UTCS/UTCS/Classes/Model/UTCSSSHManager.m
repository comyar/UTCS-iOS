//
//  UTCSSSHAuthHandler.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/2/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSSHManager.h"
#import <NMSSH/NMSSH.h>

static NSString * const host = @"weretaco.cs.utexas.edu";

@interface UTCSSSHManager ()
@property (nonatomic) NMSSHSession *session;
@property (nonatomic, getter = isConnected)       BOOL connected;
@property (nonatomic, getter = isAuthenticated)   BOOL authenticated;
@end

@implementation UTCSSSHManager

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Cannot initialize singleton object UTCSSSHAuthHandler"
                                 userInfo:nil];
}

- (instancetype)_init
{
    if(self = [super init]) {
        self.connected = NO;
        self.authenticated = NO;
        [NMSSHLogger logger].logLevel = NMSSHLogLevelVerbose;
    }
    return self;
}

+ (UTCSSSHManager *)sharedSSHManager
{
    static UTCSSSHManager *sharedSSHAuthHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSSHAuthHandler = [[self alloc]_init];
    });
    return sharedSSHAuthHandler;
}

- (void)connectWithUsername:(NSString *)username password:(NSString *)password completion:(void (^)(BOOL))completion
{
    if(self.isAuthenticated) {
        completion(YES);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        self.session = [NMSSHSession connectToHost:host withUsername:username];
        if(self.session.connected) {
            if([self.session authenticateByPassword:password]) {
                completion(YES);
            } else {
                completion(NO);
            }
        } else {
            completion(NO);
        }
    });
    
}

- (void)executeCommand:(NSString *)command completion:(void (^)(NSString *))completion
{
    if(!self.isAuthenticated) {
        completion(nil);
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSString *response = [self.session.channel execute:command error:nil];
        completion(response);
    });
}

- (void)disconnect
{
    [self.session disconnect];
}

- (BOOL)isAuthenticated
{
    return self.session.isAuthorized;
}

- (BOOL)isConnected
{
    return self.session.isConnected;
}

@end

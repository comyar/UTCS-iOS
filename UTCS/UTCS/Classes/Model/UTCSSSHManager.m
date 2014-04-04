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

+ (UTCSSSHManager *)sharedSSHAuthHandler
{
    static UTCSSSHManager *sharedSSHAuthHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSSHAuthHandler = [[self alloc]_init];
    });
    return sharedSSHAuthHandler;
}

- (BOOL)connectWithUsername:(NSString *)username password:(NSString *)password
{
    if(self.isAuthenticated) {
        return YES;
    }
    
    self.session = [NMSSHSession connectToHost:host withUsername:username];
    if(self.session.connected) {
        [self.session authenticateByPassword:password];
        if(self.session.authorized) {
            return YES;
        }
    }
    return NO;
    
}

- (NSString *)executeCommand:(NSString *)command
{
    if(!self.isAuthenticated) {
        return nil;
    }
    
    return [self.session.channel execute:command error:nil];
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

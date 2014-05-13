//
//  UTCSAuthenticationManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAuthenticationManager.h"
#import <NMSSH/NMSSH.h>

static NSString * const server = @"cs.utexas.edu";

NSString * const UTCSAuthenticationErrorDomain = @"UTCSAuthenticationErrorDomain";

#pragma mark UTCSAuthenticationManager Class Extension

@interface UTCSAuthenticationManager ()

@property (nonatomic) NSArray *hosts;

@end


#pragma mark UTCSAuthenticationManager Implementation

@implementation UTCSAuthenticationManager

+ (UTCSAuthenticationManager *)sharedManager
{
    static UTCSAuthenticationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UTCSAuthenticationManager alloc]_init];
    });
    return sharedManager;
}

- (instancetype)_init
{
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle]pathForResource:@"hosts" ofType:@"plist"];
        self.hosts = [NSArray arrayWithContentsOfFile:path];
    }
    return self;
}

- (void)authenticateUser:(NSString *)user withPassword:(NSString *)password completion:(UTCSAuthenticationCompletion)completion
{
    if (self.authenticated) {
        if (completion) {
            completion(YES, nil);
        }
        return;
    }
    
    NSString *host = [self randomHost];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NMSSHSession *session = [NMSSHSession connectToHost:host withUsername:user];
        if (session.isConnected) {
            [session authenticateByPassword:password];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (session.isAuthorized) {
                    _authenticated = YES;
                    if (completion) {
                        completion(YES, nil);
                    }
                } else {
                    if (completion) {
                        completion(NO, [NSError errorWithDomain:UTCSAuthenticationErrorDomain
                                                           code:UTCSAuthenticationAccessDeniedErrorCode
                                                       userInfo:nil]);
                    }
                }
                [session disconnect];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [session disconnect];
                if (completion) {
                    completion(NO, [NSError errorWithDomain:UTCSAuthenticationErrorDomain
                                                       code:UTCSAuthenticationConnectionErrorCode
                                                   userInfo:nil]);
                }
            });
        }
    });
}

#pragma mark Helpers

- (NSString *)randomHost
{
    NSInteger index = arc4random() % [self.hosts count];
    NSString *host = self.hosts[index];
    return [NSString stringWithFormat:@"%@.%@", host, server];
}

@end

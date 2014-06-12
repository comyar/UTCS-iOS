//
//  UTCSAuthenticationManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/13/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSStateManager.h"
#import "UTCSAuthenticationManager.h"


#pragma mark - Constants

// Server address minus the host
static NSString * const server                  = @"cs.utexas.edu";

// Name of the plist containing the array of host names
static NSString * const hostFilename            = @"hosts";

// Error domain for errors returned by the authentication manager
NSString * const UTCSAuthenticationErrorDomain  = @"UTCSAuthenticationErrorDomain";


#pragma mark UTCSAuthenticationManager Class Extension

@interface UTCSAuthenticationManager ()

// Hosts to use for authentication
@property (nonatomic) NSArray *hosts;

@end


#pragma mark - UTCSAuthenticationManager Implementation

@implementation UTCSAuthenticationManager

#pragma mark Getting a Authentication Manager

- (instancetype)init
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform selector %@ of singleton", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

- (instancetype)_init
{
    if (self = [super init]) {
        NSString *path  = [[NSBundle mainBundle]pathForResource:hostFilename ofType:@"plist"];
        self.hosts      = [NSArray arrayWithContentsOfFile:path];
        _authenticated  = [UTCSStateManager sharedManager].authenticated;
    }
    return self;
}

+ (UTCSAuthenticationManager *)sharedManager
{
    static UTCSAuthenticationManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UTCSAuthenticationManager alloc]_init];
    });
    return sharedManager;
}

#pragma mark Using the Authentication Manager

- (void)authenticateUser:(NSString *)user withPassword:(NSString *)password completion:(UTCSAuthenticationCompletion)completion
{
    // Return immediately if already authenticated
    if (self.authenticated) {
        if (completion) {
            completion(YES, nil);
        }
        return;
    }
    
    // Select a random host
    NSString *host = [self randomHost];
    
    __block NSString *blockPassword = password; 
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        // Create an SSH session
        NMSSHSession *session = [NMSSHSession connectToHost:host withUsername:user];
        if (session.isConnected) {
            
            // Authenticate with password
            [session authenticateByPassword:blockPassword];
            blockPassword = nil; // nil out password immediately
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // If session is authorized
                if (session.isAuthorized) {
                    _authenticated = YES;
                    [UTCSStateManager sharedManager].authenticated = _authenticated;
                    if (completion) {
                        completion(YES, nil);
                    }
                } else {
                    // Authorization fails due to incorrect credentials
                    if (completion) {
                        completion(NO, [NSError errorWithDomain:UTCSAuthenticationErrorDomain
                                                           code:UTCSAuthenticationAccessDeniedErrorCode
                                                       userInfo:nil]);
                    }
                }
                [session disconnect];   // Close the session
            });
        } else {
            
            // Authentication fails if there is a connection error
            dispatch_async(dispatch_get_main_queue(), ^{
                [session disconnect];   // Close the session
                if (completion) {
                    completion(NO, [NSError errorWithDomain:UTCSAuthenticationErrorDomain
                                                       code:UTCSAuthenticationConnectionErrorCode
                                                   userInfo:nil]);
                }
            });
        }
    });
}

#pragma mark Helper

- (NSString *)randomHost
{
    NSInteger index = arc4random() % [self.hosts count];
    NSString *host = self.hosts[index];
    return [NSString stringWithFormat:@"%@.%@", host, server];
}

@end

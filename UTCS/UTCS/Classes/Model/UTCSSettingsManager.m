//
//  UTCSSettingsManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSSettingsManager.h"


static NSString * const usernameKey = @"username";


#pragma mark - UTCSSettingsManager Implementation

@implementation UTCSSettingsManager
@synthesize username = _username;

- (instancetype)init
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Cannot initialize singleton"
                                 userInfo:nil];
}

- (instancetype)_init
{
    if (self = [super init]) {
        
    }
    return self;
}

+ (UTCSSettingsManager *)sharedSettingsManager
{
    static UTCSSettingsManager *sharedSettingsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettingsManager = [[UTCSSettingsManager alloc]_init];
    });
    return sharedSettingsManager;
}

- (NSString *)username
{
    if (!_username) {
        _username = [[NSUserDefaults standardUserDefaults]stringForKey:usernameKey];
    }
    return _username;
}

- (void)setUsername:(NSString *)username
{
    _username = username;
    
    if (_username) {
        [[NSUserDefaults standardUserDefaults]setObject:username forKey:username];
    }
    
}

@end

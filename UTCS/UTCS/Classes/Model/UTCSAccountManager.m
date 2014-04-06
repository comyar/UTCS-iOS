//
//  UTCSAccountManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAccountManager.h"
#import "UTCSKeychainStore.h"

static NSString * const UTCSAccountManagerNameKey = @"UTCSAccountManagerNameKey";
static NSString * const UTCSAccountManagerUsernameKey = @"UTCSAccountManagerUsernameKey";
static NSString * const UTCSAccountManagerPasswordKey = @"UTCSAccountManagerPasswordKey";


@implementation UTCSAccountManager

+ (NSString *)username
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:UTCSAccountManagerUsernameKey];
}

+ (NSString *)name
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:UTCSAccountManagerNameKey];
}

+ (NSString *)password
{
    NSString *username = [UTCSAccountManager username];
    
    if(!username) {
        return nil;
    }
    
    return [[UTCSKeychainStore sharedKeychainStore]itemForKey:UTCSAccountManagerPasswordKey account:username];
}

+ (void)setName:(NSString *)name
{
    if(!name) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:name forKey:UTCSAccountManagerNameKey];
}

+ (void)setUsername:(NSString *)username
{
    if(!username) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:username forKey:UTCSAccountManagerUsernameKey];
}

+ (void)setPassword:(NSString *)password
{
    if(!password) {
        return;
    }
    
    NSString *username = [UTCSAccountManager username];
    if(username) {
        [[UTCSKeychainStore sharedKeychainStore]setItem:password forKey:UTCSAccountManagerPasswordKey account:username];
    }
}

@end

//
//  UTCSSettingsManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSStateManager.h"


static NSString * const starredEventIDsKey = @"starredEventIDs";


#pragma mark - UTCSSettingsManager Implementation

@implementation UTCSStateManager

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
        _starredEventIDs = [self loadArrayWithKey:starredEventIDsKey];
    }
    return self;
}

+ (UTCSStateManager *)sharedManager
{
    static UTCSStateManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UTCSStateManager alloc]_init];
    });
    return sharedManager;
}

#pragma mark Starred Events

- (void)setStarredEventIDs:(NSArray *)starredEventIDs
{
    _starredEventIDs = starredEventIDs;
    [self saveArray:_starredEventIDs withKey:starredEventIDsKey];
}

#pragma mark Helpers

- (void)saveArray:(NSArray *)array withKey:(NSString *)key
{
    if (array) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        if (data) {
            [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
        }
    }
}

- (NSArray *)loadArrayWithKey:(NSString *)key
{
    NSData *data = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    if (data) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return array;
    }
    return nil;
}

@end

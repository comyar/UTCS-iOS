//
//  UTCSKeychainStore.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSKeychainStore.h"

static NSString *_defaultService;

@interface UTCSKeychainStore ()
@property (nonatomic) NSMutableDictionary *dirtyItems;
@end

@implementation UTCSKeychainStore



+ (NSString *)defaultService
{
    if(!_defaultService) {
        _defaultService = [[NSBundle mainBundle]bundleIdentifier];
    }
    return _defaultService;
}

+ (void)setDefaultService:(NSString *)service
{
    _defaultService = service;
}



+ (UTCSKeychainStore *)sharedKeychainStore
{
    static UTCSKeychainStore *sharedKeychainStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedKeychainStore = [[UTCSKeychainStore alloc]initWithService:[UTCSKeychainStore defaultService]];
    });
    return sharedKeychainStore;
}

- (instancetype)initWithService:(NSString *)service
{
    if(self = [super init]) {
        _service = [service copy];
    }
    return self;
}


@end

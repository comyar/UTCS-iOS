//
//  UTCSKeychainStore.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 */
@interface UTCSKeychainStore : NSObject

+ (NSString *)defaultService;

+ (UTCSKeychainStore *)sharedKeychainStore;

- (void)setString:(NSString *)value forKey:(NSString *)key;

@property (nonatomic, readonly) NSString *service;
@property (nonatomic, readonly) NSString *accessGroup;

@end

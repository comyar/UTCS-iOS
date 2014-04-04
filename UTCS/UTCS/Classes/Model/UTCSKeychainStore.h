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

- (NSString *)itemForKey:(NSString *)key account:(NSString *)account;
- (BOOL)setItem:(NSString *)item forKey:(NSString *)key account:(NSString *)account;
- (void)removeAllItems;


@property (nonatomic, readonly) NSString *service;

@end

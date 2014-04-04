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

#pragma mark Using a Keychain Store

- (NSString *)itemForKey:(NSString *)key account:(NSString *)account
{
    if(!key || !account) {
        return nil;
    }
    
#if TARGET_IPHONE_SIMULATOR
    // Nothing is stored in the simulator
    return nil;
#endif
    
    NSMutableDictionary *query = [NSMutableDictionary new];
    [query setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id<NSCopying>)(kSecClass)];
    [query setObject:(__bridge id)(kCFBooleanTrue) forKey:(__bridge id<NSCopying>)(kSecReturnData)];
    [query setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [query setObject:_defaultService forKey:(__bridge id<NSCopying>)(kSecAttrService)];
    [query setObject:key forKey:(__bridge id<NSCopying>)(kSecAttrGeneric)];
    [query setObject:account forKey:(__bridge id<NSCopying>)(kSecAttrAccount)];

    CFTypeRef dataRef = nil;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), &dataRef);
    if(status != errSecSuccess) {
        return nil;
    }
    
    NSData *data = [NSData dataWithData:(__bridge NSData *)(dataRef)];
    if(dataRef) {
        CFRelease(dataRef);
    }
    
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


- (BOOL)setItem:(NSString *)item forKey:(NSString *)key account:(NSString *)account
{
    if(!key || !account || !item) {
        return NO;
    }
    
#if TARGET_IPHONE_SIMULATOR
    // Simulator's keychain is unecnrypted.
    // Store nothing in simulator
    return NO;
#endif
    
    // Build query to search keychain
    NSMutableDictionary *query = [NSMutableDictionary new];
    [query setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id<NSCopying>)(kSecClass)];
    [query setObject:_defaultService forKey:(__bridge id<NSCopying>)(kSecAttrService)];
    [query setObject:key forKey:(__bridge id<NSCopying>)(kSecAttrGeneric)];
    [query setObject:account forKey:(__bridge id<NSCopying>)(kSecAttrAccount)];
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)(query), NULL);
    
    if(status == errSecSuccess) {
        // An item exists in the keychain with the set account and service
        // Update its data
        
        NSData *data = [item dataUsingEncoding:NSUTF8StringEncoding];
        if(data) {
            NSMutableDictionary *attributesToUpdate = [NSMutableDictionary new];
            [attributesToUpdate setObject:data forKey:(__bridge id<NSCopying>)(kSecValueData)];
            
            status = SecItemUpdate((__bridge CFDictionaryRef)(query), (__bridge CFDictionaryRef)(attributesToUpdate));
            if(status != errSecSuccess) {
                return NO;
            }
        } else {
            // remove
        }
    } else if(status == errSecItemNotFound) {
        // No item was found in the keychain with matching account and service
        // Add new item to keychain
        
        NSMutableDictionary *attributes = [NSMutableDictionary new];
        [attributes setObject:(__bridge id)(kSecClassGenericPassword) forKey:(__bridge id<NSCopying>)(kSecClass)];
        [attributes setObject:_defaultService forKey:(__bridge id<NSCopying>)(kSecAttrService)];
        [attributes setObject:key forKey:(__bridge id<NSCopying>)(kSecAttrGeneric)];
        [attributes setObject:account forKey:(__bridge id<NSCopying>)(kSecAttrAccount)];
        
        // item only accessible while device unlocked
        [attributes setObject:(__bridge id)(kSecAttrAccessibleWhenUnlockedThisDeviceOnly) forKey:(__bridge id<NSCopying>)(kSecAttrAccessible)];
        
        status = SecItemAdd((__bridge CFDictionaryRef)(attributes), NULL);
        if(status != errSecSuccess) {
            return NO;
        }
    } else {
        // something went very wrong
        return NO;
    }
    
    return YES;
}

- (void)removeAllItems
{
    
#warning unimplemented
    
}

@end

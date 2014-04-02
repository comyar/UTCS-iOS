//
//  UTCSKeyChainItem.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/2/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Security/Security.h>

/*
    The KeychainItemWrapper class is an abstraction layer for the iPhone Keychain communication. It is merely a 
    simple wrapper to provide a distinct barrier between all the idiosyncracies involved with the Keychain
    CF/NS container objects.
*/
@interface UTCSKeyChainItem : NSObject
{
    NSMutableDictionary *keychainItemData;		// The actual keychain item data backing store.
    NSMutableDictionary *genericPasswordQuery;	// A placeholder for the generic keychain item query used to locate the item.
}

@property (nonatomic, retain) NSMutableDictionary *keychainItemData;
@property (nonatomic, retain) NSMutableDictionary *genericPasswordQuery;

// Designated initializer.
- (id)initWithIdentifier: (NSString *)identifier accessGroup:(NSString *) accessGroup;
- (void)setObject:(id)inObject forKey:(id)key;
- (id)objectForKey:(id)key;

// Initializes and resets the default generic keychain item data.
- (void)resetKeychainItem;

@end
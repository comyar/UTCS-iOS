//
//  UTCSAccountManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTCSAccountManager : NSObject

+ (NSString *)name;

+ (NSString *)username;
+ (NSString *)password;

+ (void)setName:(NSString *)name;
+ (void)setUsername:(NSString *)username;
+ (void)setPassword:(NSString *)password;

@end

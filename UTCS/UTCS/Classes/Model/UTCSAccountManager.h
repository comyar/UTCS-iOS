//
//  UTCSAccountManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTCSAccountManager : NSObject

+ (NSString *)username;
+ (NSString *)password;

+ (void)setUsername:(NSString *)username;
+ (void)setPassword:(NSString *)password;

@end

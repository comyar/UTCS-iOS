//
//  UTCSSettingsManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/2/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTCSStateManager : NSObject

+ (NSArray *)directory;

+ (void)setDirectory:(NSArray *)directory;

@end

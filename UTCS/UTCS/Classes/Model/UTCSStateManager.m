//
//  UTCSSettingsManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/2/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSStateManager.h"

@implementation UTCSStateManager

+ (NSArray *)directory
{
    NSData *directory = [[NSUserDefaults standardUserDefaults]objectForKey:@"directory"];
    if(directory) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:directory];
    }
    return nil;
}

+ (void)setDirectory:(NSArray *)directory
{
    if(directory) {
        NSData *directoryData = [NSKeyedArchiver archivedDataWithRootObject:directory];
        [[NSUserDefaults standardUserDefaults]setObject:directoryData forKey:@"directory"];
    }
}

@end

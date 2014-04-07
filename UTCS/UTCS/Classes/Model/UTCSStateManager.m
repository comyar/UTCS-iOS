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

+ (void)setFlatDirectory:(NSArray *)flatDirectory
{
    if(flatDirectory) {
        NSData *flatDirectoryData = [NSKeyedArchiver archivedDataWithRootObject:flatDirectory];
        [[NSUserDefaults standardUserDefaults]setObject:flatDirectoryData forKey:@"flatDirectory"];
    }
}

+ (NSArray *)flatDirectory
{
    NSData *flatDirectory = [[NSUserDefaults standardUserDefaults]objectForKey:@"flatDirectory"];
    if(flatDirectory) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:flatDirectory];
    }
    return nil;
}

@end

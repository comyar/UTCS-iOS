//
//  UTCSUpdateTextFactory.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSUpdateTextFactory.h"

@implementation UTCSUpdateTextFactory

+ (NSString *)randomUpdateText
{
    NSArray *updateTexts = @[@"Fetching", @"Decoding", @"Executing"];
    NSInteger randIndex = arc4random() % [updateTexts count];
    return updateTexts[randIndex];
}

@end

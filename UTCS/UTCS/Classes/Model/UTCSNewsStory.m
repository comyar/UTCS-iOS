//
//  UTCSNewsArticle.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsStory.h"

NSString *const UTCSParseNewsStoryTitle     = @"title";
NSString *const UTCSParseNewsStoryDate      = @"date";
NSString *const UTCSParseNewStoryJSON       = @"json";

@implementation UTCSNewsStory


+ (UTCSNewsStory *)newsStoryWithParseObject:(PFObject *)object
{
    return [[UTCSNewsStory alloc]initWithParseObject:object];
}

- (instancetype)initWithParseObject:(PFObject *)object
{
    if(self = [super init]) {
        _title              = object[UTCSParseNewsStoryTitle];
        _date               = object[UTCSParseNewsStoryDate];
        _json               = object[UTCSParseNewStoryJSON];
    }
    return self;
}

@end

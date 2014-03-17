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
NSString *const UTCSParseNewStoryHTML       = @"html";

@implementation UTCSNewsStory


+ (UTCSNewsStory *)newsStoryWithParseObject:(PFObject *)object
{
    return [UTCSNewsStory newsStoryWithParseObject:object attributedContent:nil];
}

+ (UTCSNewsStory *)newsStoryWithParseObject:(PFObject *)object attributedContent:(NSAttributedString *)attributedContent
{
    return [[UTCSNewsStory alloc]initWithParseObject:object attributedContent:attributedContent];
}

- (instancetype)initWithParseObject:(PFObject *)object
{
    return [self initWithParseObject:object attributedContent:nil];
}

- (instancetype)initWithParseObject:(PFObject *)object attributedContent:(NSAttributedString *)attributedContent
{
    if(self = [super init]) {
        _title              = object[UTCSParseNewsStoryTitle];
        _date               = object[UTCSParseNewsStoryDate];
        _html               = object[UTCSParseNewStoryHTML];
        _attributedContent  = attributedContent;
    }
    return self;
}

@end

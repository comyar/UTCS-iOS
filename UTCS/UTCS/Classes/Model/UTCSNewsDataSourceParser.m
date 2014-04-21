//
//  UTCSNewsDataSourceParser.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsDataSourceParser.h"
#import "UTCSNewsArticle.h"



#pragma mark - UTCSNewsDataSourceParser Implementation

@implementation UTCSNewsDataSourceParser

- (id)parseValues:(NSArray *)values
{
    NSMutableArray *articles = [NSMutableArray new];
    for (NSDictionary *articleData in values) {
        UTCSNewsArticle *article = [UTCSNewsArticle new];
        article.html    = articleData[@"html"];
        article.title   = articleData[@"title"];
        article.url     = articleData[@"url"];
        article.date    = [self.dateFormatter dateFromString:articleData[@"date"]];
        [articles addObject:article];
    }
    return articles;
}

@end

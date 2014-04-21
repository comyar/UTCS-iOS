//
//  UTCSNewsStoryDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// Models
#import "UTCSNewsArticle.h"
#import "UTCSCacheManager.h"
#import "UTCSDataRequestServicer.h"
#import "UTCSNewsDataSource.h"

// Views
#import "UTCSTableViewCell.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIImage+CZScaling.h"
#import "UIImage+ImageEffects.h"


#pragma mark - Constants

// Key used to cache news articles
static NSString * const articlesCacheKey            = @"articles";

// Minimum time between updates, in seconds
static CGFloat minimumTimeBetweenUpdates            = 21600.0;  // 6 hours


#pragma mark - UTCSNewsStoryDataSource Class Extension

@interface UTCSNewsDataSource ()

// Array of news articles
@property (nonatomic) NSArray *newsArticles;

// Date formatter
@property (nonatomic) NSDateFormatter *dateFormatter;

@end


#pragma mark - UTCSNewsStoryDataSource Implementation

@implementation UTCSNewsDataSource

- (instancetype)init
{
    if (self = [super init]) {
        self.dateFormatter = ({
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss"; // Ex: 2014-04-19 14:27:47
            dateFormatter;
        });
    }
    return self;
}

#pragma mark UITableViewDataSource Methods

- (UTCSTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSTableViewCell"];
    if(!cell) {
        cell = [[UTCSTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSTableViewCell"];
        cell.accessoryView = ({
            UIImage *image = [[UIImage imageNamed:@"rightArrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            imageView;
        });
        cell.textLabel.numberOfLines = 4;
        cell.detailTextLabel.numberOfLines = 4;
    }
    
    UTCSNewsArticle *newsStory = self.newsArticles[indexPath.row];
    cell.textLabel.text = newsStory.title;
    cell.detailTextLabel.text = [newsStory.attributedContent string];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsArticles count];
}

#pragma mark Using a News Story Data Source

- (void)updateNewsArticlesWithCompletion:(UTCSNewsArticleDataSourceCompletion)completion
{
    NSDictionary *cache = [UTCSCacheManager cacheForService:UTCSNewsService withKey:articlesCacheKey];
    UTCSCacheMetaData *metaData = cache[UTCSCacheMetaDataName];
    
    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < minimumTimeBetweenUpdates) {
        self.newsArticles = cache[UTCSCacheValuesName];
        
        if (completion) {
            completion(metaData.timestamp);
        }
        return;
    }
    
    [UTCSDataRequestServicer sendDataRequestWithType:UTCSDataRequestNews argument:nil success:^(NSDictionary *meta, NSDictionary *values) {
        if ([meta[@"service"] isEqualToString:UTCSNewsService] && meta[@"success"]) {
            
            NSMutableArray *articles = [NSMutableArray new];
            for (NSDictionary *articleData in values) {
                UTCSNewsArticle *article    = [UTCSNewsArticle new];
                article.title               = (articleData[@"title"]    == [NSNull null])? nil : articleData[@"title"];
                article.html                = (articleData[@"html"]     == [NSNull null])? nil : articleData[@"html"];
                article.url                 = (articleData[@"url"]      == [NSNull null])? nil : articleData[@"url"];
    
                NSString *dateString        = (articleData[@"date"]     == [NSNull null])? nil : articleData[@"date"];
                article.date                = [self.dateFormatter dateFromString:dateString];
                
                [articles addObject:article];
            }
            
            self.newsArticles = articles;
            
            [UTCSCacheManager cacheObject:self.newsArticles forService:UTCSNewsService withKey:articlesCacheKey];
        }
        
        if (completion) {
            completion([NSDate date]);
        }
        
    } failure:^(NSError *error) {
        if (completion) {
            completion(metaData.timestamp);
        }
    }];
}


@end
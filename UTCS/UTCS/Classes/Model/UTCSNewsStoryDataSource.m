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
#import "UTCSNewsStoryDataSource.h"
#import "UTCSDataRequestServicer.h"

// Views
#import "UTCSTableViewCell.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIImage+CZScaling.h"
#import "UIImage+ImageEffects.h"


#pragma mark - UTCSNewsStoryDataSource Class Extension

@interface UTCSNewsStoryDataSource ()

// Overidden newsStories property
@property (nonatomic) NSArray *newsArticles;

// Date formatter
@property (nonatomic) NSDateFormatter *dateFormatter;

@end


#pragma mark - UTCSNewsStoryDataSource Implementation

@implementation UTCSNewsStoryDataSource

- (instancetype)init
{
    if (self = [super init]) {
        self.dateFormatter = [NSDateFormatter new];
        
        // Ex: 2014-04-19 14:27:47
        self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
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

- (void)updateNewsStoriesWithCompletion:(void (^)(void))completion
{
    [UTCSDataRequestServicer sendDataRequestWithType:UTCSDataRequestNews argument:nil success:^(NSDictionary *meta, NSDictionary *values) {
        if ([meta[@"service"] isEqualToString:UTCSNewsService] && meta[@"success"]) {
            
            NSMutableArray *articles = [NSMutableArray new];
            for (NSDictionary *articleData in values) {
                UTCSNewsArticle *article = [UTCSNewsArticle new];
                article.title   = articleData[@"title"];
                article.html    = articleData[@"html"];
                article.url     = articleData[@"url"];
                article.date    = [self.dateFormatter dateFromString:articleData[@"date"]];
                [articles addObject:article];
            }
            
            self.newsArticles = articles;
        }
        
        if (completion) {
            completion();
        }
    } failure:nil];
}


@end
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



@end
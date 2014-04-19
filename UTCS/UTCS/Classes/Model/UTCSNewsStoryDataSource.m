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

@end


#pragma mark - UTCSNewsStoryDataSource Implementation

@implementation UTCSNewsStoryDataSource

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
    [UTCSDataRequestServicer sendDataRequestWithType:UTCSDataRequestNews argument:nil success:^(NSDictionary *JSON) {
        NSDictionary *meta = JSON[@"meta"];
        if ([meta[@"service"] isEqualToString:@"news"] && meta[@"success"]) {
            NSMutableArray *articles = [NSMutableArray new];
            for (NSDictionary *articleData in JSON[@"values"]) {
                UTCSNewsArticle *article = [UTCSNewsArticle new];
                article.title = articleData[@"title"];
                article.html = articleData[@"html"];
                article.url = articleData[@"url"];
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
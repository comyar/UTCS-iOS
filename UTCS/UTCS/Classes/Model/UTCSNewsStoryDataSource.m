//
//  UTCSNewsStoryDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// Models
#import "UTCSNewsStory.h"
#import "UTCSNewsStoryDataSource.h"

// Views
#import "UTCSTableViewCell.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIImage+CZScaling.h"
#import "UIImage+ImageEffects.h"


#pragma mark - Constants



typedef void (^ UTCSNewStoryManagerCompletion) (NSArray *newsStories, NSError *error);

NSString * const UTCSParseClassNews                     = @"NewsStory";

const NSTimeInterval kEarliestTimeIntervalForNews       = INT32_MIN;


#pragma mark - UTCSNewsStoryDataSource Class Extension

@interface UTCSNewsStoryDataSource ()

// Overidden newsStories property
@property (nonatomic) NSArray *newsStories;

@end


#pragma mark - UTCSNewsStoryDataSource Implementation

@implementation UTCSNewsStoryDataSource

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
    
    UTCSNewsStory *newsStory = self.newsStories[indexPath.row];
    cell.textLabel.text = newsStory.title;
    cell.detailTextLabel.text = [newsStory.attributedContent string];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsStories count];
}

- (void)updateNewsStoriesWithCompletion:(void (^)(void))completion
{
    [self newsStoriesWithCompletion:^(NSArray *newsStories, NSError *error) {
        if(newsStories) {
            self.newsStories = newsStories;
        }
        if(completion) {
            completion();
        }
    }];
}

- (void)newsStoriesWithCompletion:(UTCSNewStoryManagerCompletion)completion
{

}


@end
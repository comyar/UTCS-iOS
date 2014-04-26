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
#import "UTCSNewsDataSource.h"
#import "UTCSDataSourceCache.h"
#import "UTCSNewsDataSourceParser.h"

// Views
#import "UTCSBouncyTableViewCell.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIImage+CZScaling.h"
#import "UIImage+ImageEffects.h"


#pragma mark - Constants

// Key used to cache news articles
NSString * const UTCSNewsDataSourceCacheKey             = @"UTCSNewsDataSourceCacheKey";

static NSString * const cellAccessoryImageName          = @"rightArrow";

// News table view cell identifier
static NSString * const UTCSNewsTableViewCellIdentifier = @"UTCSNewsTableViewCell";

#pragma mark - UTCSNewsStoryDataSource Implementation

@implementation UTCSNewsDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        _parser = [UTCSNewsDataSourceParser new];
        _cache  = [[UTCSDataSourceCache alloc]initWithService:service];
        _data   = [self.cache objectWithKey:UTCSNewsDataSourceCacheKey];
    }
    return self;
}

#pragma mark UITableViewDataSource Methods

- (UTCSBouncyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSBouncyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UTCSNewsTableViewCellIdentifier];
    if(!cell) {
        cell = [[UTCSBouncyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UTCSNewsTableViewCellIdentifier];
        cell.accessoryView = ({
            UIImage *image          = [[UIImage imageNamed:cellAccessoryImageName]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView  = [[UIImageView alloc]initWithImage:image];
            imageView.tintColor     = [UIColor colorWithWhite:1.0 alpha:0.5];
            imageView;
        });
        cell.textLabel.numberOfLines        = 4;
        cell.detailTextLabel.numberOfLines  = 4;
    }
    
    UTCSNewsArticle *newsStory = self.data[indexPath.row];
    cell.textLabel.text = newsStory.title;
    cell.detailTextLabel.text = [newsStory.attributedContent string];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

@end

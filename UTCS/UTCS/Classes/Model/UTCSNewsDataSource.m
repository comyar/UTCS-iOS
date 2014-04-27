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

// News table view cell identifier
static NSString * const UTCSNewsTableViewCellIdentifier = @"UTCSNewsTableViewCell";

// Name of the image to use for a table view cell's accessory view
static NSString * const cellAccessoryImageName          = @"rightArrow";


#pragma mark - UTCSNewsStoryDataSource Implementation

@implementation UTCSNewsDataSource

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        _minimumTimeBetweenUpdates = 86400; // 24 hours
        _parser = [UTCSNewsDataSourceParser new];
        _cache  = [[UTCSDataSourceCache alloc]initWithService:service];
        _primaryCacheKey = UTCSNewsDataSourceCacheKey;
        
        NSDictionary *cache = [self.cache objectWithKey:UTCSNewsDataSourceCacheKey];
        if (cache) {
            UTCSDataSourceCacheMetaData *meta = cache[UTCSDataSourceCacheMetaDataName];
            _data = cache[UTCSDataSourceCacheValuesName];
            _updated = meta.timestamp;
        }
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
    
    UTCSNewsArticle *newsStory  = self.data[indexPath.row];
    
    cell.textLabel.text         = newsStory.title;
    cell.detailTextLabel.text   = [newsStory.attributedContent string];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count];
}

@end

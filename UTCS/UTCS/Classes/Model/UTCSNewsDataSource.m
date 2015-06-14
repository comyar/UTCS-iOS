//
//  UTCSNewsStoryDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSNewsArticle.h"
#import "UTCSNewsDataSource.h"
#import "UTCSDataSourceCache.h"
#import "UTCSNewsDataSourceParser.h"

#import "UIImage+CZTinting.h"
#import "UIImage+CZScaling.h"
#import "UIImage+ImageEffects.h"


#pragma mark - Constants

// Name of the news service.
NSString * const UTCSNewsServiceName                    = @"news";

// Key used to cache news articles.
NSString * const UTCSNewsDataSourceCacheKey             = @"UTCSNewsDataSourceCacheKey";

// News table view cell identifier.
static NSString * const UTCSNewsTableViewCellIdentifier = @"UTCSNewsTableViewCell";

// Name of the image to use for a table view cell's accessory view.
static NSString * const cellAccessoryImageName          = @"rightArrow";

// Minimum time between updates
static const NSTimeInterval minimumTimeBetweenUpdates   = 86400.0;  // 24 hours


#pragma mark - UTCSNewsStoryDataSource Implementation

@implementation UTCSNewsDataSource

#pragma mark Creating a Data Source

- (instancetype)initWithService:(NSString *)service
{
    if (self = [super initWithService:service]) {
        _minimumTimeBetweenUpdates = minimumTimeBetweenUpdates;
        _parser = [UTCSNewsDataSourceParser new];
        
        _primaryCacheKey = UTCSNewsDataSourceCacheKey;
        _cache  = [[UTCSDataSourceCache alloc]initWithService:service];
        
        // Check for cached data
        NSDictionary *cache = [self.cache objectWithKey:UTCSNewsDataSourceCacheKey];
        UTCSDataSourceCacheMetaData *meta = cache[UTCSDataSourceCacheMetaDataName];
        _data       = cache[UTCSDataSourceCacheValuesName];
        _updated    = meta.timestamp;
    }
    return self;
}

#pragma mark UITableViewDataSource Methods

- (BouncyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BouncyTableViewCell *cell   = [tableView dequeueReusableCellWithIdentifier:UTCSNewsTableViewCellIdentifier];
    
    if(!cell) {
        cell = [[BouncyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UTCSNewsTableViewCellIdentifier];
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

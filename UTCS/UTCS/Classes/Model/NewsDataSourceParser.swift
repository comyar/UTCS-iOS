//
//  UTCSNewsDataSourceParser.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSNewsDataSourceParser.h"
#import "UTCSNewsArticle.h"
#import "UIImage+CZScaling.h"

#import "UIImage+CZTinting.h"
#import "UIImage+ImageEffects.h"


#pragma mark - Constants

// Key for the article title in the serialized data
static NSString * const titleKey            = @"title";

// Key for the article url in the serialized data
static NSString * const urlKey              = @"url";

// Key for the article date in the serialized data
static NSString * const dateKey             = @"date";

// Key for the article html in the serialized data
static NSString * const htmlKey             = @"noImgHtml";

// Key for the article image URLs in the serialized data
static NSString * const imageUrlsKey        = @"imageUrls";

// Minimum width of an image in a news article for it to become the header image
static const CGFloat minHeaderImageWidth    = 300.0;

// Minimum height of an image in a news article for it to become the header image
static const CGFloat minHeaderImageHeight   = 250.0;


#pragma mark - UTCSNewsDataSourceParser Implementation

@implementation UTCSNewsDataSourceParser

#pragma mark Using a News Data Source Parser

- (NSArray *)parseValues:(NSArray *)values
{
    NSMutableArray *articles        = [NSMutableArray new];
    
    for (NSDictionary *articleData in values) {
        UTCSNewsArticle *article    = [UTCSNewsArticle new];
        article.title               = articleData[titleKey];
        article.url                 = articleData[urlKey];
        article.html                = articleData[htmlKey];
        article.imageURLs           = articleData[imageUrlsKey];
        article.date                = [self.dateFormatter dateFromString:articleData[@"date"]];
        [self setHeaderImageForArticle:article];
        [articles addObject:article];
    }
    
    return articles;
}

#pragma mark Helper

- (void)setHeaderImageForArticle:(UTCSNewsArticle *)article
{
    __block BOOL foundHeader = NO;
    for (NSString *url in article.imageURLs) {
        if (foundHeader) {
            return;
        }
        
        // Do synchronously on a background thread so update isn't finished until all headers are downloaded
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            
            NSURLResponse *response;
            NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
            
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                
                if (image.size.width >= minHeaderImageWidth && image.size.height >= minHeaderImageHeight) {
                    
                    // Scale the images (aspect fill scale)
                    image                 = [UIImage scaleImage:image toSize:CGSizeMake(320.0, 284.0)];
                    UIImage *blurredImage = [UIImage scaleImage:image toSize:CGSizeMake(0.25 * minHeaderImageWidth, 0.25 * minHeaderImageHeight)];
            
                    // Blur and tint
                    article.headerImage = [image tintedImageWithColor:[UIColor colorWithWhite:0.1 alpha:0.75] blendingMode:kCGBlendModeOverlay];
                    article.headerBlurredImage = [blurredImage applyBlurWithRadius:20.0
                                                                         tintColor:[UIColor colorWithWhite:0.1 alpha:0.75]
                                                             saturationDeltaFactor:1.8
                                                                         maskImage:nil];
                    foundHeader = YES;
                }
            }
        });
    }
}

@end

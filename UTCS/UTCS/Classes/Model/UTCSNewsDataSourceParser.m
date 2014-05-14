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

#import "UIImage+ImageEffects.h"
#import "UIImage+CZTinting.h"
#import <AFNetworking/AFNetworking.h>

#pragma mark - Constants

// Minimum width of an image in a news article for it to become the header image
static const CGFloat minHeaderImageWidth    = 300.0;
static const CGFloat minHeaderImageHeight   = 250.0;

#pragma mark - UTCSNewsDataSourceParser Implementation

@implementation UTCSNewsDataSourceParser

- (NSArray *)parseValues:(NSArray *)values
{
    NSMutableArray *articles = [NSMutableArray new];
    for (NSDictionary *articleData in values) {
        UTCSNewsArticle *article    = [UTCSNewsArticle new];
        article.html                = articleData[@"noImgHtml"];
        article.title               = articleData[@"title"];
        article.url                 = articleData[@"url"];
        article.imageURLs           = articleData[@"imageUrls"];
        article.date                = [self.dateFormatter dateFromString:articleData[@"date"]];
        [self setHeaderImageForArticle:article];
        [articles addObject:article];
    }
    return articles;
}

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
                    image = [UIImage scaleImage:image toSize:CGSizeMake(320.0, 284.0)];
                    UIImage *blurredImage = [UIImage scaleImage:image toSize:CGSizeMake(80.0, 71.0)];
                    
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

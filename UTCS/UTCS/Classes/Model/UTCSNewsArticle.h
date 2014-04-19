//
//  UTCSNewsArticle.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;


/**
 UTCSNewsArticle represents a single news article available on the UTCS News RSS feed.
 */
@interface UTCSNewsArticle : NSObject <NSCoding>

// -----
// @name Properties
// -----

/**
 Title of the news article
 */
@property (nonatomic) NSString                  *title;

/**
 URL to the news article online
 */
@property (nonatomic) NSString                  *url;

/**
 Date the news article was published
 */
@property (nonatomic) NSDate                    *date;

/**
 HTML content of the news article
 */
@property (nonatomic) NSString                  *html;

/**
 Attributed content parsed from the HTML content
 */
@property (nonatomic) NSAttributedString        *attributedContent;

/**
 Header image of the news article. 
 
 Parsed from the HTML content, may be nil
 */
@property (nonatomic) UIImage                   *headerImage;

/**
 Blurred header image of the news article
 
 Parsed from the HTML content, may be nil
 */
@property (nonatomic) UIImage                   *headerBlurredImage;

@end

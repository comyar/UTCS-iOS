//
//  UTCSNewsArticle.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;


/**
 UTCSNewsArticle is a concrete object that represents a single UTCS news article.
 */
@interface UTCSNewsArticle : NSObject <NSCoding>

// -----
// @name Properties
// -----

/**
 Title of the news article.
 */
@property (nonatomic) NSString                  *title;

/**
 URL to the news article online.
 */
@property (nonatomic) NSString                  *url;

/**
 Date the news article was published.
 */
@property (nonatomic) NSDate                    *date;

/**
 HTML content of the news article.
 */
@property (nonatomic) NSString                  *html;

/**
 Attributed content parsed from the HTML content.
 */
@property (nonatomic) NSAttributedString        *attributedContent;

/**
 Header image of the news article. 
 
 Parsed from the HTML content. May be nil if an appropriately large
 image is not found in the HTML of a news article.
 */
@property (nonatomic) UIImage                   *headerImage;

/**
 Blurred header image of the news article
 
 Parsed from the HTML content. May be nil if an appropriately large
 image is not found in the HTML of a news article.
 */
@property (nonatomic) UIImage                   *headerBlurredImage;

@end

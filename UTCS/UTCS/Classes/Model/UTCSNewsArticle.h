//
//  UTCSNewsArticle.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;


/**
 */
@interface UTCSNewsArticle : NSObject <NSCoding>

// -----
// @name Properties
// -----

/**
 */
@property (nonatomic) NSString                  *title;

/**
 */
@property (nonatomic) NSString                  *url;

/**
 */
@property (nonatomic) NSDate                    *date;

/**
 */
@property (nonatomic) NSString                  *html;

/**
 */
@property (nonatomic) NSAttributedString        *attributedContent;

/**
 */
@property (nonatomic) UIImage                   *headerImage;

/**
 */
@property (nonatomic) UIImage                   *headerBlurredImage;

@end

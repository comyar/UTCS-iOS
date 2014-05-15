//
//  UTCSNewsDetailViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

@import UIKit;


#pragma mark - Forward Declarations

@class UTCSNewsArticle;


#pragma mark - UTCSNewsDetailViewController Interface

/**
 UTCSNewsDetailViewController is a concrete subclass of UIViewController that displays 
 a single news article.
 */
@interface UTCSNewsDetailViewController : UIViewController <UITextViewDelegate>

// -----
// @name Properties
// -----

#pragma mark Properties

/**
 News article to display.
 
 Should be set before presenting this view controller.
 */
@property (strong, nonatomic) UTCSNewsArticle *newsArticle;

@end

//
//  UTCSNewsDetailViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UTCSNewsArticle;

/**
 */
@interface UTCSNewsDetailViewController : UIViewController <UITextViewDelegate>

/**
 */
@property (strong, nonatomic) UTCSNewsArticle *newsStory;

@end

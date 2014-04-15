//
//  UTCSHeaderBlurTableView.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/27/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UTCSBackgroundHeaderBlurTableView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic) UIImage                   *backgroundImage;

@property (nonatomic) UIImage                   *backgroundBlurredImage;

@property (nonatomic, readonly) UIView          *header;

@property (nonatomic, readonly) UITableView     *tableView;

@end

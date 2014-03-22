//
//  UTCSParallaxHeaderScrollView.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UTCSParallaxHeaderScrollView : UIScrollView

- (instancetype)initWithFrame:(CGRect)frame headerView:(UIView *)headerView;

@property (nonatomic) UIView    *headerView;

@end

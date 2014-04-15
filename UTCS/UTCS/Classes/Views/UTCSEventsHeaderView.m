//
//  UTCSEventsHeaderView.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/15/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsHeaderView.h"
#import "FBShimmeringView.h"


#pragma mark - UTCSEventsHeaderView Class Extension

@interface UTCSEventsHeaderView ()


@end


#pragma mark - UTCSEventsHeaderView Implementation

@implementation UTCSEventsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.shimmeringView.contentView = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:48];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.text = @"UTCS Events";
            label;
        });

    }
    return self;
}

@end

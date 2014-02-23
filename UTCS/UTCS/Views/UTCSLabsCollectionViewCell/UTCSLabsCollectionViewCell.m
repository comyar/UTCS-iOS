//
//  UTCSLabsCollectionViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsCollectionViewCell.h"

@implementation UTCSLabsCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.imageView removeFromSuperview];
        self.imageView.frame = self.contentView.frame;
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

@end

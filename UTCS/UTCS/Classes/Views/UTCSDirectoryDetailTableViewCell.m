//
//  UTCSDirectoryDetailTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryDetailTableViewCell.h"

@implementation UTCSDirectoryDetailTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.bounds = CGRectMake(0.0, 0.0, CGRectGetHeight(self.bounds), CGRectGetHeight(self.bounds));
}

@end

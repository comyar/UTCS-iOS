//
//  UTCSTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSTableViewCell.h"


@implementation UTCSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    return self;
}

@end

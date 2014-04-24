//
//  UTCSDirectoryTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryTableViewCell.h"


NSString * const UTCSDirectoryAddToContactsNotification = @"UTCSDirectoryAddToContactsNotification";

@implementation UTCSDirectoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _phoneNumberLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label;
        });
        [self addSubview:_phoneNumberLabel];
        
        _officeLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label;
        });
        [self addSubview:_officeLabel];
        
        _addToContactsButton = ({
            UTCSButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.tintColor = [UIColor whiteColor];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4.0;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            button.layer.borderWidth = 1.0;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:@"Add To Contacts" forState:UIControlStateNormal];
            button;
        });
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 0.1 * self.bounds.size.height, CGRectGetWidth(self.bounds), self.textLabel.bounds.size.height);
    
    self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.textLabel.frame.origin.y + CGRectGetHeight(self.textLabel.bounds), CGRectGetWidth(self.bounds), self.detailTextLabel.bounds.size.height);
    
    
    self.officeLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, 8.0 + self.detailTextLabel.frame.origin.y + CGRectGetHeight(self.detailTextLabel.bounds), CGRectGetWidth(self.bounds) - self.detailTextLabel.frame.origin.x, 1.1 * self.officeLabel.font.pointSize);
    
    self.phoneNumberLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, 8.0 + self.officeLabel.frame.origin.y + CGRectGetHeight(self.officeLabel.bounds), CGRectGetWidth(self.bounds) - self.detailTextLabel.frame.origin.x, 1.1 * self.phoneNumberLabel.font.pointSize);
    
    self.officeLabel.alpha = self.showDetails;
    
    self.phoneNumberLabel.alpha = self.showDetails;
    
}


@end

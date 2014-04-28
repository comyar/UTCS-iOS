//
//  UTCSDirectoryTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryTableViewCell.h"



@implementation UTCSDirectoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _phoneNumberTextView = ({
            UITextView *textView = [UITextView new];
            textView.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            textView.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            textView.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
            textView.backgroundColor = [UIColor clearColor];
            textView.textContainerInset = UIEdgeInsetsZero;
            textView.textContainer.lineFragmentPadding = 0;
            textView.textAlignment = NSTextAlignmentLeft;
            textView.contentInset = UIEdgeInsetsZero;
            textView.tintColor = [UIColor whiteColor];
            textView.scrollEnabled = NO;
            textView.editable = NO;
            textView;
        });
        [self addSubview:_phoneNumberTextView];
        
        _officeLabel = ({
            UILabel *label = [UILabel new];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
            label.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            label;
        });
        [self addSubview:_officeLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 0.1 * self.bounds.size.height, CGRectGetWidth(self.bounds), self.textLabel.bounds.size.height);
    
    self.detailTextLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, self.textLabel.frame.origin.y + CGRectGetHeight(self.textLabel.bounds), CGRectGetWidth(self.bounds), self.detailTextLabel.bounds.size.height);
    
    self.officeLabel.frame = CGRectMake(self.detailTextLabel.frame.origin.x, 4.0 + self.detailTextLabel.frame.origin.y + CGRectGetHeight(self.detailTextLabel.bounds), CGRectGetWidth(self.bounds) - self.detailTextLabel.frame.origin.x, 1.1 * self.officeLabel.font.pointSize);
    
    
    self.phoneNumberTextView.frame = CGRectMake(self.detailTextLabel.frame.origin.x, 4.0 + self.officeLabel.frame.origin.y + CGRectGetHeight(self.officeLabel.bounds), CGRectGetWidth(self.bounds) - self.detailTextLabel.frame.origin.x, 16);
    
    if (![self.officeLabel.text length]) {
        self.phoneNumberTextView.frame = self.officeLabel.frame;
    }
}


@end

//
//  UTCSDirectoryTableViewCell.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;

#import "UTCSButton.h"

extern NSString * const UTCSDirectoryAddToContactsNotification;


@interface UTCSDirectoryTableViewCell : UITableViewCell

@property (nonatomic) BOOL showDetails;
@property (nonatomic, readonly) UILabel *officeLabel;
@property (nonatomic, readonly) UILabel *phoneNumberLabel;
@property (nonatomic, readonly) UTCSButton *addToContactsButton;


@end

//
//  UTCSDirectoryDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UIImage+CZScaling.h"
#import "UTCSDirectoryPerson.h"
#import "UIButton+UTCSButton.h"
#import "UTCSDirectoryDetailViewController.h"


#pragma mark - Constants

// Directory detail table view cell identifier.
static NSString * const UTCSDirectoryDetailTableViewCellIdentifier    = @"UTCSDirectoryDetailTableViewCell";


#pragma mark - UTCSDirectoryDetailViewController Implementation

@implementation UTCSDirectoryDetailViewController

#pragma mark Creating a Directory Detail View Controller

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.menuButton.hidden = YES;
}

#pragma mark Setters

- (void)setPerson:(UTCSDirectoryPerson *)person
{
    _person = person;
    [self.tableView reloadData];
}

#pragma mark Formatting

- (NSString *)formattedPhoneNumberWithString:(NSString *)phoneNumber
{
    if ([phoneNumber length] == 10) {
        return [NSString stringWithFormat:@"(%@) %@ - %@",
                [phoneNumber substringWithRange:NSMakeRange(0, 3)],
                [phoneNumber substringWithRange:NSMakeRange(3, 3)],
                [phoneNumber substringWithRange:NSMakeRange(6, 4)]];
    }
    return phoneNumber;
}

#pragma mark Buttons

- (void)didTouchUpInsideButton:(UIButton *)button
{
    if (button.tag == NSIntegerMin) {
        [[[UIAlertView alloc]initWithTitle:@"Confirm"
                                  message:@"Are you sure you want to call?"
                                 delegate:self
                        cancelButtonTitle:@"Cancel"
                        otherButtonTitles:@"Yes", nil]show];
    }
}

#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *phoneNumber = self.person.phoneNumber;
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]];
        if ([[UIApplication sharedApplication]canOpenURL:phoneURL]) {
            [[UIApplication sharedApplication]openURL:phoneURL];
        } else {
#if !(TARGET_IPHONE_SIMULATOR)
            [[[UIAlertView alloc]initWithTitle:@"Error"
                                       message:@"Ouch! Looks like something went wrong. Please report a bug! "
                                      delegate:self
                             cancelButtonTitle:@"Meh, Ok"
                             otherButtonTitles:nil]show];
#else
            NSLog(@"iPhone Simulator cannot open URL : %@", phoneURL);
#endif
        }
    }
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UTCSDirectoryDetailTableViewCellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:UTCSDirectoryDetailTableViewCellIdentifier];
        
        cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        cell.textLabel.numberOfLines = 2;
        
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        
        cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
        cell.imageView.autoresizingMask = UIViewAutoresizingNone;
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        UIButton *callButton = ({
            UIButton *button = [UIButton bouncyButton];
            button.frame = CGRectMake(0.0, 0.0, 50.0, 28.0);
            button.center = CGPointMake(cell.width - button.width, cell.center.y);
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            [button setTitle:@"Call" forState:UIControlStateNormal];
            button.tintColor = [UIColor whiteColor];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4.0;
            button.layer.borderWidth = 1.0;
            button.tag = NSIntegerMin;
            button;
        });
        
        [cell.contentView addSubview:callButton];
    }
    
    UIButton *callButton = (UIButton *)[cell.contentView viewWithTag:NSIntegerMin];
    callButton.hidden = YES;
    
    if (indexPath.section == 0) {
        cell.textLabel.text         = self.person.fullName;
        cell.detailTextLabel.text   = self.person.type;
        
        if (self.person.imageURL) {
            NSURL *url = [NSURL URLWithString:self.person.imageURL];
            __weak UITableViewCell *weakCell = cell;
            
            [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:url] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                weakCell.imageView.image = [UIImage scaleImage:image toSize:CGSizeMake(64.0, 64.0)];
                weakCell.imageView.layer.cornerRadius = 32.0;
                weakCell.imageView.layer.masksToBounds = YES;
                weakCell.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [weakCell setNeedsLayout];
            } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                weakCell.imageView.image = nil;
            }];
        } else {
            cell.imageView.image = nil;
        }
        
        [cell.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSString *text      = self.person.office;
            NSString *subtitle  = @"Office";
            text        = ([text length])? text : [self formattedPhoneNumberWithString:self.person.phoneNumber];
            subtitle    = ([text length])? subtitle : @"Phone";
            cell.textLabel.text         = text;
            cell.detailTextLabel.text   = subtitle;
        } else if (indexPath.row == 1) {
            cell.textLabel.text         = [self formattedPhoneNumberWithString:self.person.phoneNumber];
            cell.detailTextLabel.text   = @"Phone";
        }
        
        if ([cell.detailTextLabel.text isEqualToString:@"Phone"]) {
            callButton.hidden = NO;
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        NSInteger count = 0;
        if (self.person.office) {
            count++;
        }
        
        if (self.person.phoneNumber) {
            count++;
        }
        return count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"Information";
    }
    return nil;
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 64.0;
    }
    return 50.0;
}

@end

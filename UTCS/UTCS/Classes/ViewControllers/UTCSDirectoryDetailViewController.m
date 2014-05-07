//
//  UTCSDirectoryDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryDetailViewController.h"
#import "UTCSDirectoryPerson.h"
#import "UIButton+UTCSButton.h"


@interface UTCSDirectoryDetailViewController ()
@property (nonatomic) UIImage *facultyImage;
@end


@implementation UTCSDirectoryDetailViewController

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.menuButton.hidden = YES;
}

- (void)setPerson:(UTCSDirectoryPerson *)person
{
    _person = person;
    self.facultyImage = nil;
    [self.tableView reloadData];
    [self downloadImageForPerson:_person];
}

- (void)downloadImageForPerson:(UTCSDirectoryPerson *)person
{
    if ([person.imageURL length]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:person.imageURL]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (person == self.person) {
                    self.facultyImage = image;
                    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
                    cell.imageView.image = image;
                }
            }
        }];
    }
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSDirectoryDetailTableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:@"UTCSDirectoryDetailTableViewCell"];
        
        cell.textLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.8];
        cell.textLabel.numberOfLines = 2;
        
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        UIButton *callButton = ({
            UIButton *button = [UIButton bouncyButton];
            [button addTarget:self action:@selector(didTouchUpInsideButton:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            [button setTitle:@"Go" forState:UIControlStateNormal];
            button.tintColor = [UIColor whiteColor];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 4.0;
            button.layer.borderWidth = 1.0;
            button;
        });
    }
    
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageView.autoresizingMask = UIViewAutoresizingNone;
    
    if (indexPath.section == 0) {
        cell.textLabel.text         = self.person.fullName;
        cell.detailTextLabel.text   = self.person.type;
        cell.imageView.image        = (self.facultyImage)? self.facultyImage : [UIImage imageNamed:[self.person.type lowercaseString]];
        cell.imageView.layer.cornerRadius = 0.5 * cell.imageView.image.size.width;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSString *text      = self.person.office;
            NSString *subtitle  = @"Office";
            text        = ([text length])? text : self.person.phoneNumber;
            subtitle    = ([text length])? subtitle : @"Phone";
            cell.textLabel.text         = text;
            cell.detailTextLabel.text   = subtitle;
        } else if (indexPath.row == 1) {
            cell.textLabel.text         = self.person.phoneNumber;
            cell.detailTextLabel.text   = @"Phone";
        }
    }
    
    return cell;
}


#pragma mark Buttons

#pragma mark UITableViewDataSource Methods

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:YES animated:YES];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setHighlighted:NO animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 64.0;
    }
    return 50.0;
}

@end

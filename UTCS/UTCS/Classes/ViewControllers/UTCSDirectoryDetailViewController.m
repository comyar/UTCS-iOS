//
//  UTCSDirectoryDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 5/6/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDirectoryDetailViewController.h"
#import "UTCSDirectoryPerson.h"



@implementation UTCSDirectoryDetailViewController

- (instancetype)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style]) {
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
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
    NSLog(@"set person");
    [self.tableView reloadData];
}

#pragma mark UITableViewDataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSDirectoryDetailTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSDirectoryDetailTableViewCell"];
    }
    
    NSLog(@"cell");
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.person.fullName;
        cell.detailTextLabel.text = self.person.type;
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            NSString *text = self.person.office;
            text = ([text length])? text : self.person.phoneNumber;
            cell.textLabel.text = text;
        } else if (indexPath.row == 1) {
            cell.textLabel.text = self.person.phoneNumber;
        }
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"num rows");
    
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
    NSLog(@"num sections");
    return 2;
}

#pragma mark UITableViewDelegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 96.0;
    }
    return 64.0;
}

@end

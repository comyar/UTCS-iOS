//
//  UTCSLabsManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsDataSource.h"
#import "UTCSLabsTableViewCell.h"
#import "UTCSLabMachine.h"
#import "FRBSwatchist.h"

@interface UTCSLabsDataSource ()
@property (nonatomic) NSDictionary *labMachineMapping;
@end


@implementation UTCSLabsDataSource

- (instancetype)init
{
    if(self = [super init]) {
        self.labMachineMapping = @{@(1): @"Basement",
                                   @(2): @"Third Floor"};
    }
    return self;
}

- (UTCSLabsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSLabsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSLabsTableViewCell"];
    if(!cell) {
        cell = [[UTCSLabsTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UTCSLabsTableViewCell"];
    }
    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.labMachines count];
}

- (void)syncLabsWithCompletion:(void (^)(BOOL success))completion
{

}

- (NSArray *)searchLabsWithSearchString:(NSString *)searchString scope:(NSString *)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(labName = %@) AND (hostname BEGINSWITH[cd] %@)", scope, searchString];
    return [self.labMachines filteredArrayUsingPredicate:predicate];
}

@end

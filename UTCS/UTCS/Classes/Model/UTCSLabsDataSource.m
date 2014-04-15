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
#import "UTCSLabMachineView.h"

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
    
    UTCSLabMachine *labMachine = self.labMachines[indexPath.row];
    cell.textLabel.text = labMachine.hostname;
    cell.detailTextLabel.text = labMachine.labName;
    cell.occupiedLabel.text = (labMachine.occupied)? @"Occupied" : @"Unoccupied";
    cell.indicatorColor = (labMachine.occupied)? [UIColor redColor] : [UIColor greenColor];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.labMachines count];
}

- (void)syncLabsWithCompletion:(void (^)(BOOL success))completion
{
    PFQuery *query = [PFQuery queryWithClassName:@"LabMachine"];
    query.limit = 1000;
    [query orderByAscending:@"name"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSMutableArray *labMachines = [NSMutableArray new];
        if(objects) {
            for(PFObject *object in objects) {
                UTCSLabMachine *labMachine = [UTCSLabMachine labMachineWithParseObject:object];
                [labMachines addObject:labMachine];
            }
            
            _labMachines = labMachines;
            
            if(completion) {
                // Save lab data
                completion(YES);
            }
            
        } else {
            if(completion) {
                completion(NO);
            }
        }
    }];
}

- (NSArray *)searchLabsWithSearchString:(NSString *)searchString scope:(NSString *)scope
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(labName = %@) AND (hostname BEGINSWITH[cd] %@)", scope, searchString];
    return [self.labMachines filteredArrayUsingPredicate:predicate];
}

#pragma mark UTCSLabViewDataSource Methods

- (UTCSLabMachineView *)labView:(UTCSLabView *)labView labMachineViewForIdentifier:(NSString *)identifier
{
    UTCSLabMachineView *labMachineView = [labView dequeueLabMachineWithIdentifier:identifier];
    labMachineView.center = CGPointMake(16.0, 16.0);
    labMachineView.backgroundColor = [UIColor redColor];
    return labMachineView;
}

- (NSArray *)labMachineViewIdentifiersForLabView:(UTCSLabView *)labView
{
    return @[@"weretaco"];
}

@end

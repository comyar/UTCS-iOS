//
//  UTCSLabsManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsManager.h"
#import "UTCSLabsTableViewCell.h"
#import "UTCSLabMachine.h"

@interface UTCSLabsManager ()
@property (nonatomic) NSDictionary *labMachineMapping;
@end


@implementation UTCSLabsManager

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
    NSLog(@"Search: %@", searchString);
    NSLog(@"Scope: %@", scope);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(labName = %@) AND (hostname BEGINSWITH[cd] %@)", scope, searchString];
    NSArray *searchResults = [self.labMachines filteredArrayUsingPredicate:predicate];
    for(UTCSLabMachine *machine in searchResults) {
        NSLog(@"%@", machine.hostname);
    }
    return searchResults;
}

@end

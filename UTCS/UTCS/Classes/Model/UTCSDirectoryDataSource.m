//
//  UTCSDirectoryManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/31/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

#import "UTCSDirectoryDataSource.h"
#import "UTCSDirectoryPerson.h"
#import "UTCSStateManager.h"
#import "UTCSDataRequestServicer.h"

#pragma mark - Constants

// Key used to cache directory
static NSString *directoryCacheKey = @"directory";

// Key used to cache flat directory
static NSString *flatDirectoryCacheKey = @"flatDirectory";

// Minimum time between updates, in seconds
static CGFloat minimumTimeBetweenUpdates    = 2592000.0;  // 30 days


@interface UTCSDirectoryDataSource ()
@property (nonatomic) NSArray *directory;
@property (nonatomic) NSArray *flatDirectory;
@end

@implementation UTCSDirectoryDataSource

- (instancetype)init
{
    if(self = [super init]) {
        _directory = [UTCSStateManager directory];
        _flatDirectory = [UTCSStateManager flatDirectory];
    }
    return self;
}

- (BOOL)directoryNeedsUpdate
{
//    NSDictionary *cache = [UTCSCacheManager cacheForService:UTCSEventsService withKey:directoryCacheKey];
//    UTCSDataSourceCacheMetaData *metaData = cache[UTCSCacheMetaDataName];
    
//    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < minimumTimeBetweenUpdates) {
//        return NO;
//    }
    
    return YES;
}

- (void)updateDirectoryWithCompletion:(UTCSDirectoryDataSourceCompletion)completion
{
//    NSDictionary *cache = [UTCSCacheManager cacheForService:UTCSDirectoryService withKey:directoryCacheKey];
//    UTCSDataSourceCacheMetaData *metaData = cache[UTCSCacheMetaDataName];
//    
//    if (metaData && [[NSDate date]timeIntervalSinceDate:metaData.timestamp] < minimumTimeBetweenUpdates) {
//        NSLog(@"Directory : Cache hit");
//        
//        if (completion) {
//            completion(metaData.timestamp);
//        }
//        
//        return;
//    }
//    
//    NSLog(@"Directory : Cache miss");
//    
//    [UTCSDataRequestServicer sendDataRequestWithType:UTCSDataRequestDirectory argument:nil success:^(NSDictionary *meta, NSDictionary *values) {
//        if ([meta[@"service"] isEqualToString:UTCSDirectoryService] && meta[@"success"]) {
//            NSMutableArray *directory = [NSMutableArray new];
//            NSMutableArray *flatDirectory = [NSMutableArray new];
//            
//            for (NSArray *letter in values) {
//                NSMutableArray *directoryLetter = [NSMutableArray new];
//                for (NSDictionary *personData in letter) {
//                    UTCSDirectoryPerson *person = [UTCSDirectoryPerson new];
//                    person.firstName    = personData[@"fName"];
//                    person.lastName     = personData[@"lName"];
//                    person.fullName     = personData[@"name"];
//                    person.office       = personData[@"location"];
//                    person.phoneNumber  = personData[@"phone"];
//                    person.type         = personData[@"type"];
//                    [directoryLetter addObject:person];
//                    [flatDirectory addObject:person];
//                }
//                [directory addObject:directoryLetter];
//            }
//            
//            self.directory = directory;
//            self.flatDirectory = flatDirectory;
//            
//            [UTCSCacheManager cacheObject:self.directory forService:UTCSDirectoryService withKey:directoryCacheKey];
//            [UTCSCacheManager cacheObject:self.flatDirectory forService:UTCSDirectoryService withKey:flatDirectoryCacheKey];
//        }
//        
//        if (completion) {
//            completion();
//        }
//        
//    } failure:^(NSError *error) {
//        
//        if (completion) {
//            completion();
//        }
//        
//    }];

}

- (NSArray *)searchDirectoryWithSearchString:(NSString *)searchString scope:(NSString *)scope
{
    NSPredicate *predicate = nil;
    if([scope isEqualToString:@"All"]) {
        predicate = [NSPredicate predicateWithFormat:@"(firstName BEGINSWITH[cd] %@) or (lastName BEGINSWITH[cd] %@) or (fullName BEGINSWITH[cd] %@)", scope, searchString, searchString, searchString];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"(type = %@) AND ((firstName BEGINSWITH[cd] %@) or (lastName BEGINSWITH[cd] %@) or (fullName BEGINSWITH[cd] %@))", scope, searchString, searchString, searchString];
    }
    NSArray *searchResults = [self.flatDirectory filteredArrayUsingPredicate:predicate];
    return searchResults;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSDirectoryTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSDirectoryTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
    UTCSDirectoryPerson *person = nil;
    if(tableView == self.searchDisplayController.searchResultsTableView) {
        
    } else {
        person = self.directory[indexPath.section][indexPath.row];
    }
    NSMutableAttributedString *attributedName = [[NSMutableAttributedString alloc]initWithString:person.fullName];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:cell.textLabel.font.pointSize] range:NSMakeRange(0, [person.firstName length])];
    [attributedName addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:cell.textLabel.font.pointSize] range:NSMakeRange([person.firstName length] + 1, [person.lastName length])];
    
    cell.textLabel.attributedText = attributedName;
    cell.detailTextLabel.text = person.type;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.directory[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.directory count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    UTCSDirectoryPerson *person = self.directory[section][0];
    return [[person.lastName substringToIndex:1]uppercaseString];
}

@end

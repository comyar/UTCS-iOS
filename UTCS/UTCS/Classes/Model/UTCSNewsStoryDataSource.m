//
//  UTCSNewsStoryDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsStoryDataSource.h"
#import "UTCSNewsStory.h"

typedef void (^ UTCSNewStoryManagerCompletion) (NSArray *newsStories, NSError *error);

NSString * const cellIdentifier = @"UTCSNewsTableViewCell";

NSString * const UTCSParseClassNews                     = @"News";

NSString * const UTCSNewsStoryTitleFontAttribute        = @"UTCSNewsStoryTitleFontAttribute";
NSString * const UTCSNewsStoryTitleFontColorAttribute   = @"UTCSNewsStoryTitleFontColorAttribute";

NSString * const UTCSNewsStoryDateFontAttribute         = @"UTCSNewsStoryDateFontAttribute";
NSString * const UTCSNewsStoryDateFontColorAttribute    = @"UTCSNewsStoryDateFontColorAttribute";

NSString * const UTCSNewsStoryTextFontAttribute         = @"UTCSNewsStoryTextFontAttribute";
NSString * const UTCSNewsStoryTextFontColorAttribute    = @"UTCSNewsStoryTextFontColorAttribute";

NSString * const UTCSNewsStoryParagraphLineSpacing      = @"UTCSNewsStoryParagraphLineSpacing";

const NSTimeInterval kEarliestTimeIntervalForNews   = INT32_MIN;

@interface UTCSNewsStoryDataSource ()

@property (nonatomic) NSArray   *newsStories;
@end


@implementation UTCSNewsStoryDataSource

- (instancetype)init
{
    if(self = [super init]) {
        
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.numberOfLines = 2;
        NSLog(@"asdnlf");
    }
    UTCSNewsStory *newsStory = self.newsStories[indexPath.row];
    
    cell.textLabel.text = newsStory.title;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsStories count];
}

- (void)updateNewsStories:(void (^)(void))completion
{
    [self newsStoriesWithFontAttributes:nil completion:^(NSArray *newsStories, NSError *error) {
        if(newsStories) {
            self.newsStories = newsStories;
        }
        if(completion) {
            completion();
        }
    }];
}

- (void)newsStoriesWithFontAttributes:(NSDictionary *)attributes completion:(UTCSNewStoryManagerCompletion)completion
{
    PFQuery *query = [PFQuery queryWithClassName:UTCSParseClassNews];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:UTCSParseNewsStoryDate greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:kEarliestTimeIntervalForNews]];
    
    [query findObjectsInBackgroundWithBlock: ^ (NSArray *objects, NSError *error) {
        NSArray *sortedNewsStories = nil;
        NSMutableArray *newsStories = [NSMutableArray new];
        if(objects) {
            for(PFObject *object in objects) {
                UTCSNewsStory *newsStory = [UTCSNewsStory newsStoryWithParseObject:object attributedContent:nil];
                [newsStories addObject:newsStory];
            }
            
            sortedNewsStories = [newsStories sortedArrayUsingComparator: ^ NSComparisonResult(id obj1, id obj2) {
                UTCSNewsStory *story1 = (UTCSNewsStory *)obj1;
                UTCSNewsStory *story2 = (UTCSNewsStory *)obj2;
                return [story2.date compare:story1.date];
            }];
            
        }
        completion(sortedNewsStories, error);
    }];
}

@end

//
//  UTCSNewsStoryDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsStoryDataSource.h"
#import "UIImage+ImageEffects.h"
#import "UTCSNewsStory.h"

#import "UIImage+CZScaling.h"


typedef void (^ UTCSNewStoryManagerCompletion) (NSArray *newsStories, NSError *error);

NSString * const UTCSParseClassNews                     = @"NewsStory";

const NSTimeInterval kEarliestTimeIntervalForNews       = INT32_MIN;


@implementation UTCSNewsStoryDataSource

- (instancetype)init
{
    if(self = [super init]) {
        
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSNewsTableViewCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSNewsTableViewCell"];
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.textLabel.numberOfLines = 4;
        cell.textLabel.textColor = [UIColor whiteColor];
        
        cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        cell.detailTextLabel.numberOfLines = 4;
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    UTCSNewsStory *newsStory = self.newsStories[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = newsStory.title;
    cell.detailTextLabel.text = [newsStory.attributedContent string];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsStories count];
}

- (void)updateNewsStories:(void (^)(void))completion
{
    [self newsStoriesWithCompletion:^(NSArray *newsStories, NSError *error) {
        if(newsStories) {
            self.newsStories = newsStories;
        }
        if(completion) {
            completion();
        }
    }];
}

- (void)newsStoriesWithCompletion:(UTCSNewStoryManagerCompletion)completion
{
    PFQuery *query = [PFQuery queryWithClassName:UTCSParseClassNews];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:UTCSParseNewsStoryDate greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:kEarliestTimeIntervalForNews]];
    
    [query findObjectsInBackgroundWithBlock: ^ (NSArray *objects, NSError *error) {
        NSArray *sortedNewsStories = nil;
        NSMutableArray *newsStories = [NSMutableArray new];
        if(objects) {
            for(PFObject *object in objects) {
                UTCSNewsStory *newsStory = [UTCSNewsStory newsStoryWithParseObject:object];
                if([self setAttributedContentForNewsStory:newsStory]) {
                    [newsStories addObject:newsStory];
                }
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

- (BOOL)setAttributedContentForNewsStory:(UTCSNewsStory *)newsStory
{
    NSMutableAttributedString *attributedHTML = [[[NSAttributedString alloc]initWithData:[newsStory.html dataUsingEncoding:NSUTF32StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil]mutableCopy];
    if(!attributedHTML) {
        return NO;
    }
    
    __block UIImage *headerImage = nil;
    NSMutableAttributedString *attributedContent = [NSMutableAttributedString new];
    [attributedHTML enumerateAttributesInRange:NSMakeRange(0, [attributedHTML length])
                                          options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                       usingBlock:
     ^ (NSDictionary *attrs, NSRange range, BOOL *stop) {
         if(attrs[NSAttachmentAttributeName]) {
             NSTextAttachment *textAttachment = attrs[NSAttachmentAttributeName];
             if(!headerImage && textAttachment.image) {
                 if(textAttachment.image.size.width >= 200) {
                     headerImage = [textAttachment.image copy];
                 }
             }
         } else {
             UIFont *htmlFont = attrs[NSFontAttributeName];
             NSMutableDictionary *fontDescriptorAttributes = [[[htmlFont fontDescriptor]fontAttributes]mutableCopy];
             fontDescriptorAttributes[UIFontDescriptorNameAttribute] = @"Palatino-Roman";
             UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:fontDescriptorAttributes];
             UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:1.4 * htmlFont.pointSize];
             [attributedHTML addAttribute:NSFontAttributeName value:font range:range];
             [attributedContent appendAttributedString:[attributedHTML attributedSubstringFromRange:range]];
         }
    }];
    
    newsStory.headerImage = [headerImage applyTintEffectWithColor:[UIColor colorWithWhite:0.11 alpha:0.73]];
    newsStory.blurredHeaderImage = [headerImage applyDarkEffect];
    newsStory.attributedContent = attributedContent;
    
    return YES;
}


@end
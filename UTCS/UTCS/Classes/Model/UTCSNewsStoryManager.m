//
//  UTCSNewsStoryManager.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/16/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsStoryManager.h"
#import "UTCSNewsStory.h"

NSString * const UTCSParseClassNews                     = @"News";

NSString * const UTCSNewsStoryTitleFontAttribute        = @"UTCSNewsStoryTitleFontAttribute";
NSString * const UTCSNewsStoryTitleFontColorAttribute   = @"UTCSNewsStoryTitleFontColorAttribute";

NSString * const UTCSNewsStoryDateFontAttribute         = @"UTCSNewsStoryDateFontAttribute";
NSString * const UTCSNewsStoryDateFontColorAttribute    = @"UTCSNewsStoryDateFontColorAttribute";

NSString * const UTCSNewsStoryTextFontAttribute         = @"UTCSNewsStoryTextFontAttribute";
NSString * const UTCSNewsStoryTextFontColorAttribute    = @"UTCSNewsStoryTextFontColorAttribute";

NSString * const UTCSNewsStoryParagraphLineSpacing      = @"UTCSNewsStoryParagraphLineSpacing";

const NSTimeInterval kEarliestTimeIntervalForNews   = INT32_MIN;


#pragma mark - UTCSNewStoryManager Implementation

@implementation UTCSNewsStoryManager

+ (void)newsStoriesWithFontAttributes:(NSDictionary *)attributes completion:(UTCSNewStoryManagerCompletion)completion
{
    PFQuery *query = [PFQuery queryWithClassName:UTCSParseClassNews];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:UTCSParseNewsStoryDate greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:kEarliestTimeIntervalForNews]];
    
    [query findObjectsInBackgroundWithBlock: ^ (NSArray *objects, NSError *error) {
        NSArray *sortedNewsStories = nil;
        NSMutableArray *newsStories = [NSMutableArray new];
        NSMutableArray *monthDividedNewStories = [NSMutableArray new];
        if(objects) {
            for(PFObject *object in objects) {
                UTCSNewsStory *newsStory = [UTCSNewsStory newsStoryWithParseObject:object attributedContent:nil];
                newsStory.attributedContent = [self attributedContentForNewsStory:newsStory withFontAttributes:attributes];
                [newsStories addObject:newsStory];
            }
            
            sortedNewsStories = [newsStories sortedArrayUsingComparator: ^ NSComparisonResult(id obj1, id obj2) {
                UTCSNewsStory *story1 = (UTCSNewsStory *)obj1;
                UTCSNewsStory *story2 = (UTCSNewsStory *)obj2;
                return [story2.date compare:story1.date];
            }];
            
            NSInteger currentMonth = -1;
            for(UTCSNewsStory *newsStory in sortedNewsStories) {
                NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:newsStory.date];
                NSInteger month = [dateComponents month];
                if(month != currentMonth) {
                    NSMutableArray *newMonthArray = [NSMutableArray arrayWithObject:newsStory];
                    [monthDividedNewStories addObject:newMonthArray];
                    currentMonth = month;
                } else {
                    NSMutableArray *monthArray = [monthDividedNewStories lastObject];
                    [monthArray addObject:newsStory];
                }
            }
            
        }
        completion(monthDividedNewStories, error);
    }];
}

+ (NSAttributedString *)attributedContentForNewsStory:(UTCSNewsStory *)newsStory withFontAttributes:(NSDictionary *)attributes
{
    NSMutableAttributedString *attributedString = [NSMutableAttributedString new];
//    
//    // Title
//    NSString *titleText = [NSString stringWithFormat:@"%@\n", newsStory.title];
//    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc]initWithString:titleText attributes:@{NSFontAttributeName: attributes[UTCSNewsStoryTitleFontAttribute], NSForegroundColorAttributeName: attributes[UTCSNewsStoryTitleFontColorAttribute]}];
//    [attributedString appendAttributedString:titleAttributedString];
//    
//    
//    // Date
//    NSString *dateText = [NSString stringWithFormat:@"%@\n\n\n", [NSDateFormatter localizedStringFromDate:newsStory.date
//                                                                                                dateStyle:NSDateFormatterLongStyle
//                                                                                                timeStyle:NSDateFormatterNoStyle]];
//    NSMutableAttributedString *dateAttributedString = [[NSMutableAttributedString alloc]initWithString:dateText attributes:@{NSFontAttributeName: attributes[UTCSNewsStoryDateFontAttribute], NSForegroundColorAttributeName:attributes[UTCSNewsStoryDateFontColorAttribute]}];
//    [attributedString appendAttributedString:dateAttributedString];
//    
//    
//    // Content
//    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc]initWithData:[newsStory.html dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
//    
//    UIFont *font = attributes[UTCSNewsStoryTextFontAttribute];
//    UIColor *textColor = attributes[UTCSNewsStoryTextFontColorAttribute];
//    [contentAttributedString enumerateAttributesInRange:NSMakeRange(0, [contentAttributedString length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock: ^ (NSDictionary *attrs, NSRange range, BOOL *stop) {
//        
////        if(!attrs[NSAttachmentAttributeName]) {
//            UIFont *currentFont = attrs[NSFontAttributeName];
//            UIFontDescriptorSymbolicTraits currentFontSymbolicTraits = [[currentFont fontDescriptor]symbolicTraits];
//            UIFontDescriptor *newFontDescriptor = [[font fontDescriptor] fontDescriptorWithSymbolicTraits:currentFontSymbolicTraits];
//            UIFont *newFont = [UIFont fontWithDescriptor:newFontDescriptor size:font.pointSize];
//        
//            [contentAttributedString setAttributes:@{NSFontAttributeName: newFont, NSForegroundColorAttributeName:textColor} range:range];
////        }
//    }];
//    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
//    paragraphStyle.lineSpacing = [attributes[UTCSNewsStoryParagraphLineSpacing]floatValue];
//    
//    [contentAttributedString addAttribute:NSParagraphStyleAttributeName
//                                    value:paragraphStyle
//                                    range:NSMakeRange(0, [contentAttributedString length])];
//    [attributedString appendAttributedString:contentAttributedString];
    
    return attributedString;
}


@end

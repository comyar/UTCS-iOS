//
//  UTCSNewsArticle.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsStory.h"

NSString *const UTCSParseNewsStoryTitle     = @"title";
NSString *const UTCSParseNewsStoryDate      = @"date";
NSString *const UTCSParseNewsStoryHTMLText  = @"text";

NSString *const UTCSNewsStoryDetailNormalFont   = @"UTCSNewsStoryDetailNormalFont";
NSString *const UTCSNewsStoryDetailNormalColor  = @"UTCSNewsStoryDetailNormalColor";
NSString *const UTCSNewsStoryDetailBoldFont     = @"UTCSNewsStoryDetailBoldFont";
NSString *const UTCSNewsStoryDetailBoldColor    = @"UTCSNewsStoryDetailBoldColor";


@implementation UTCSNewsStory

+ (UTCSNewsStory *)newsStoryWithParseObject:(PFObject *)object
{
    return [[UTCSNewsStory alloc]initWithParseObject:object];
}

- (instancetype)initWithParseObject:(PFObject *)object
{
    if(self = [super init]) {
        _title = object[UTCSParseNewsStoryTitle];
        _date = object[UTCSParseNewsStoryDate];
        _HTMLText = object[UTCSParseNewsStoryHTMLText];
    }
    return self;
}

- (void)initializeAttributedTextWithAttributes:(NSDictionary *)attributes;
{
    if([_HTMLText length] == 0) {
        _attributedText = [NSAttributedString new];
    } else {
        
        NSData *descriptionData = [_HTMLText dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithData:descriptionData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        UIFont  *normalFont     = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        UIColor *normalColor    = [UIColor darkGrayColor];
        
        UIFont  *boldFont       = [UIFont fontWithName:@"HelveticaNeue" size:16];
        UIColor *boldColor      = [UIColor blackColor];
        
        if(attributes) {
            normalFont     = (attributes[UTCSNewsStoryDetailNormalFont])? attributes[UTCSNewsStoryDetailNormalFont]     : normalFont;
            normalColor    = (attributes[UTCSNewsStoryDetailNormalColor])? attributes[UTCSNewsStoryDetailNormalColor]   : normalColor;
            boldFont       = (attributes[UTCSNewsStoryDetailBoldFont])? attributes[UTCSNewsStoryDetailBoldFont]         : boldFont;
            boldColor      = (attributes[UTCSNewsStoryDetailBoldColor])? attributes[UTCSNewsStoryDetailBoldColor]       : boldColor;
        }
        
        [attributedText enumerateAttributesInRange:NSMakeRange(0, [attributedText length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock: ^ (NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            UIFont *currentFont = attrs[NSFontAttributeName];
            NSString *fontName  = [currentFont.fontName lowercaseString];
            
            if([fontName rangeOfString:@"bold"].location != NSNotFound) {
                [attributedText addAttribute:NSForegroundColorAttributeName value:boldColor range:range];
                [attributedText addAttribute:NSFontAttributeName value:boldFont range:range];
            } else {
                [attributedText addAttribute:NSForegroundColorAttributeName value:normalColor range:range];
                [attributedText addAttribute:NSFontAttributeName value:normalFont range:range];
            }
        }];
        
        _attributedText = attributedText;
    }

}

@end

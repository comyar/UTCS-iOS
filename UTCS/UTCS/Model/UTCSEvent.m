//
//  UTCSEvent.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEvent.h"

NSString * const UTCSParseEventName             = @"name";
NSString * const UTCSParseEventContactName      = @"contactName";
NSString * const UTCSParseEventContactEmail     = @"contactEmail";
NSString * const UTCSParseEventLocation         = @"location";
NSString * const UTCSParseEventHTMLDescription  = @"description";
NSString * const UTCSParseEventStartDate        = @"dateStart";
NSString * const UTCSParseEventEndDate          = @"dateEnd";


@implementation UTCSEvent

+ (UTCSEvent *)eventWithParseObject:(PFObject *)object
{
    return [[UTCSEvent alloc]initWithParseObject:object];
}

- (instancetype)initWithParseObject:(PFObject *)object
{
    if(self = [super init]) {
        _name           = object[UTCSParseEventName];
        _contactName    = object[UTCSParseEventContactName];
        _contactEmail   = object[UTCSParseEventContactEmail];
        _location       = object[UTCSParseEventLocation];
        _startDate      = object[UTCSParseEventStartDate];
        _endDate        = object[UTCSParseEventEndDate];
        _HTMLDescription = object[UTCSParseEventHTMLDescription];
    }
    return self;
}

- (void)initializeAttributedDescriptionWithBoldFont:(UIFont *)boldFont font:(UIFont *)font
{
    if([_HTMLDescription length] == 0) {
        NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc]initWithString:@"Description Unavailable"];
        NSRange range = NSMakeRange(0, [attributedDescription length]);
        [attributedDescription addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
        [attributedDescription addAttribute:NSFontAttributeName value:font range:range];
        _attributedDescription = attributedDescription;
        
    } else {
        
        NSData *descriptionData = [_HTMLDescription dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc]initWithData:descriptionData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        [attributedDescription enumerateAttributesInRange:NSMakeRange(0, [attributedDescription length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock: ^ (NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            UIFont *currentFont = attrs[NSFontAttributeName];
            NSString *fontName  = [currentFont.fontName lowercaseString];
            
            if([fontName rangeOfString:@"bold"].location != NSNotFound) {
                [attributedDescription addAttribute:NSForegroundColorAttributeName value:[UIColor darkGrayColor] range:range];
                [attributedDescription addAttribute:NSFontAttributeName value:boldFont range:range];
            } else {
                [attributedDescription addAttribute:NSForegroundColorAttributeName
                                              value:[UIColor darkGrayColor]
                                              range:range];
                [attributedDescription addAttribute:NSFontAttributeName
                                              value:font
                                              range:range];
            }
        }];
        
        _attributedDescription = attributedDescription;
    }
}

@end

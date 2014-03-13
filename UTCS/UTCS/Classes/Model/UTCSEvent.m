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

NSString *const UTCSEventDetailBoldFont     = @"UTCSEventDetailBoldFont";
NSString *const UTCSEventDetailBoldColor    = @"UTCSEventDetailBoldColor";
NSString *const UTCSEventDetailNormalFont   = @"UTCSEventDetailNormalFont";
NSString *const UTCSEventDetailNormalColor  = @"UTCSEventDetailNormalColor";

@implementation UTCSEvent

+ (UTCSEvent *)eventWithParseObject:(PFObject *)object
{
    return [[UTCSEvent alloc]initWithParseObject:object];
}

- (instancetype)initWithParseObject:(PFObject *)object
{
    if(self = [super init]) {
        _name               = object[UTCSParseEventName];
        _contactName        = object[UTCSParseEventContactName];
        _contactEmail       = object[UTCSParseEventContactEmail];
        _location           = object[UTCSParseEventLocation];
        _startDate          = object[UTCSParseEventStartDate];
        _endDate            = object[UTCSParseEventEndDate];
        _HTMLDescription    = object[UTCSParseEventHTMLDescription];
    }
    return self;
}

- (void)initializeAttributedDescriptionWithAttributes:(NSDictionary *)attributes
{
    if([_HTMLDescription length] == 0) {
        _attributedDescription = [NSAttributedString new];
    } else {
        
        NSData *descriptionData = [_HTMLDescription dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc]initWithData:descriptionData options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        UIFont  *normalFont     = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
        UIColor *normalColor    = [UIColor darkGrayColor];
        
        UIFont  *boldFont       = [UIFont fontWithName:@"HelveticaNeue" size:16];
        UIColor *boldColor      = [UIColor blackColor];
        
        if(attributes) {
            normalFont     = (attributes[UTCSEventDetailNormalFont])? attributes[UTCSEventDetailNormalFont]     : normalFont;
            normalColor    = (attributes[UTCSEventDetailNormalColor])? attributes[UTCSEventDetailNormalColor]   : normalColor;
            boldFont       = (attributes[UTCSEventDetailBoldFont])? attributes[UTCSEventDetailBoldFont]         : boldFont;
            boldColor      = (attributes[UTCSEventDetailBoldColor])? attributes[UTCSEventDetailBoldColor]       : boldColor;
        }
        
        [attributedDescription enumerateAttributesInRange:NSMakeRange(0, [attributedDescription length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock: ^ (NSDictionary *attrs, NSRange range, BOOL *stop) {
            
            UIFont *currentFont = attrs[NSFontAttributeName];
            NSString *fontName  = [currentFont.fontName lowercaseString];
            
            if([fontName rangeOfString:@"bold"].location != NSNotFound) {
                [attributedDescription addAttribute:NSForegroundColorAttributeName value:boldColor range:range];
                [attributedDescription addAttribute:NSFontAttributeName value:boldFont range:range];
            } else {
                [attributedDescription addAttribute:NSForegroundColorAttributeName value:normalColor range:range];
                [attributedDescription addAttribute:NSFontAttributeName value:normalFont range:range];
            }
        }];
        
        _attributedDescription = attributedDescription;
    }
}

@end

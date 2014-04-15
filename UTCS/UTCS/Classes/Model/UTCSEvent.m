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
        _name               = object[UTCSParseEventName];
        _contactName        = object[UTCSParseEventContactName];
        _contactEmail       = object[UTCSParseEventContactEmail];
        _location           = object[UTCSParseEventLocation];
        _startDate          = object[UTCSParseEventStartDate];
        _endDate            = object[UTCSParseEventEndDate];
        _HTMLDescription    = object[UTCSParseEventHTMLDescription];
        _allDay             = object[@"allday"];
        _tag                = object[@"type"];
        [self setAttributedDescriptionForWithHTML:_HTMLDescription];
        
    }
    return self;
}

- (void)setAttributedDescriptionForWithHTML:(NSString *)htmlDescription
{
    NSMutableAttributedString *attributedHTML = [[[NSAttributedString alloc]initWithData:[htmlDescription dataUsingEncoding:NSUTF32StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil]mutableCopy];
    if(!attributedHTML) {
        return;
    }
    
    NSMutableAttributedString *attributedContent = [NSMutableAttributedString new];
    [attributedHTML enumerateAttributesInRange:NSMakeRange(0, [attributedHTML length])
                                       options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                    usingBlock:
     ^ (NSDictionary *attrs, NSRange range, BOOL *stop) {
         UIFont *htmlFont = attrs[NSFontAttributeName];
         NSMutableDictionary *fontDescriptorAttributes = [[[htmlFont fontDescriptor]fontAttributes]mutableCopy];
         fontDescriptorAttributes[UIFontDescriptorNameAttribute] = @"HelveticaNeue-Light";
         UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:fontDescriptorAttributes];
         UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:1.25 * htmlFont.pointSize];
         NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
         paragraphStyle.lineSpacing = 6.0;
         paragraphStyle.paragraphSpacing = 16.0;
         
         [attributedHTML addAttribute:NSFontAttributeName value:font range:range];
         [attributedHTML addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
         [attributedContent appendAttributedString:[attributedHTML attributedSubstringFromRange:range]];
     }];
    
    _attributedDescription = attributedContent;
}

@end

//
//  UTCSEvent.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

// Models
#import "UTCSEvent.h"


#pragma mark - Constants

// NSCoding keys
static NSString * const nameKey                     = @"name";
static NSString * const contactNameKey              = @"contactName";
static NSString * const contactEmailKey             = @"contactEmail";
static NSString * const locationKey                 = @"location";
static NSString * const descriptionKey              = @"description";
static NSString * const attributedDescriptionKey    = @"attributedDescription";
static NSString * const typeKey                     = @"type";
static NSString * const linkKey                     = @"link";
static NSString * const startDateKey                = @"startDate";
static NSString * const endDateKey                  = @"endDate";
static NSString * const allDayKey                   = @"allDay";
static NSString * const foodKey                     = @"food";


#pragma mark - UTCSEvent Implementation

@implementation UTCSEvent

#pragma mark NSCoding Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        _name                   = [aDecoder decodeObjectForKey:nameKey];
        _contactName            = [aDecoder decodeObjectForKey:contactNameKey];
        _contactEmail           = [aDecoder decodeObjectForKey:contactEmailKey];
        _location               = [aDecoder decodeObjectForKey:locationKey];
        _description            = [aDecoder decodeObjectForKey:descriptionKey];
        _attributedDescription  = [aDecoder decodeObjectForKey:attributedDescriptionKey];
        _type                   = [aDecoder decodeObjectForKey:typeKey];
        _link                   = [aDecoder decodeObjectForKey:linkKey];
        _startDate              = [aDecoder decodeObjectForKey:startDateKey];
        _endDate                = [aDecoder decodeObjectForKey:endDateKey];
        _allDay                 = [aDecoder decodeBoolForKey:allDayKey];
        _food                   = [aDecoder decodeBoolForKey:foodKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name                  forKey:nameKey];
    [aCoder encodeObject:_contactName           forKey:contactNameKey];
    [aCoder encodeObject:_contactEmail          forKey:contactEmailKey];
    [aCoder encodeObject:_location              forKey:locationKey];
    [aCoder encodeObject:_description           forKey:descriptionKey];
    [aCoder encodeObject:_attributedDescription forKey:attributedDescriptionKey];
    [aCoder encodeObject:_type                  forKey:typeKey];
    [aCoder encodeObject:_link                  forKey:linkKey];
    [aCoder encodeObject:_startDate             forKey:startDateKey];
    [aCoder encodeObject:_endDate               forKey:endDateKey];
    [aCoder encodeBool:_allDay                  forKey:allDayKey];
    [aCoder encodeBool:_food                    forKey:foodKey];
}

#pragma mark Setters

- (void)setDescription:(NSString *)description
{
    _description = description;
    [self setAttributedDescriptionWithHTML:_description];
}

- (void)setAttributedDescriptionWithHTML:(NSString *)html
{
    if (!html) {
        _attributedDescription = nil;
        return;
    }
    
    // Parse the HTML to construct an attributed string
    NSMutableAttributedString *attributedHTML = [[[NSAttributedString alloc]initWithData:[html dataUsingEncoding:NSUTF32StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil]mutableCopy];
    
    if (!attributedHTML) {
        _attributedDescription = nil;
        return;
    }
    
    NSMutableAttributedString *attributedContent = [NSMutableAttributedString new];
    
    // Iterate over the attributed string
    [attributedHTML enumerateAttributesInRange:NSMakeRange(0, [attributedHTML length])
                                       options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
                                    usingBlock:
     ^ (NSDictionary *attrs, NSRange range, BOOL *stop) {
         
         // Get the current font in the attributed string
         UIFont *htmlFont = attrs[NSFontAttributeName];
         NSMutableDictionary *fontDescriptorAttributes = [[[htmlFont fontDescriptor]fontAttributes]mutableCopy];
         
         // Change the font in the article
         fontDescriptorAttributes[UIFontDescriptorNameAttribute] = @"HelveticaNeue-Light";
         
         // Create a new font from the attributes
         UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:fontDescriptorAttributes];
         UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:1.25 * htmlFont.pointSize];
         
         // Configure line/paragraph spacing
         NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
         paragraphStyle.lineSpacing = 6.0;
         paragraphStyle.paragraphSpacing = 16.0;
         
         // Add the attributes to attributedHTML to simplify skipping content
         [attributedHTML addAttribute:NSFontAttributeName value:font range:range];
         [attributedHTML addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
         
         // Append the configured attributed string
         [attributedContent appendAttributedString:[attributedHTML attributedSubstringFromRange:range]];
     }];
    
    _attributedDescription = attributedContent;
}

@end

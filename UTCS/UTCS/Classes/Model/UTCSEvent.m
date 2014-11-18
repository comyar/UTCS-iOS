//
//  UTCSEvent.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSEvent.h"


#pragma mark - Constants

// Key for encoding name
static NSString * const nameKey                     = @"name";

// Key for encoding contactName
static NSString * const contactNameKey              = @"contactName";

// Key for encoding contactEmail
static NSString * const contactEmailKey             = @"contactEmail";

// Key for encoding location
static NSString * const locationKey                 = @"location";

// Key for encoding description
static NSString * const descriptionKey              = @"description";

// Key for encoding attributedDescription
static NSString * const attributedDescriptionKey    = @"attributedDescription";

// Key for encoding type
static NSString * const typeKey                     = @"type";

// Key for encoding link
static NSString * const linkKey                     = @"link";

// Key for encoding startDate
static NSString * const startDateKey                = @"startDate";

// Key for encoding endDate
static NSString * const endDateKey                  = @"endDate";

// Key for encoding allDay
static NSString * const allDayKey                   = @"allDay";

// Key for encoding food
static NSString * const foodKey                     = @"food";

// Key for encoding eventID
static NSString * const eventIDKey                  = @"eventID";

// Font name for the event description
static NSString * const eventDescriptionFontName    = @"HelveticaNeue-Light";

// Space between lines in the article text
static const CGFloat lineSpacing                    = 6.0;

// Space between paragraphs in the article text
static const CGFloat paragraphSpacing               = 16.0;

// Amount to increase the parsed font size of articles
static const CGFloat fontSizeModifier               = 1.5;


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
        _eventDescription            = [aDecoder decodeObjectForKey:descriptionKey];
        _attributedDescription  = [aDecoder decodeObjectForKey:attributedDescriptionKey];
        _type                   = [aDecoder decodeObjectForKey:typeKey];
        _link                   = [aDecoder decodeObjectForKey:linkKey];
        _startDate              = [aDecoder decodeObjectForKey:startDateKey];
        _endDate                = [aDecoder decodeObjectForKey:endDateKey];
        _allDay                 = [aDecoder decodeBoolForKey:allDayKey];
        _food                   = [aDecoder decodeBoolForKey:foodKey];
        _eventID                = [aDecoder decodeObjectForKey:eventIDKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_name                  forKey:nameKey];
    [aCoder encodeObject:_contactName           forKey:contactNameKey];
    [aCoder encodeObject:_contactEmail          forKey:contactEmailKey];
    [aCoder encodeObject:_location              forKey:locationKey];
    [aCoder encodeObject:_eventDescription           forKey:descriptionKey];
    [aCoder encodeObject:_attributedDescription forKey:attributedDescriptionKey];
    [aCoder encodeObject:_type                  forKey:typeKey];
    [aCoder encodeObject:_link                  forKey:linkKey];
    [aCoder encodeObject:_startDate             forKey:startDateKey];
    [aCoder encodeObject:_endDate               forKey:endDateKey];
    [aCoder encodeBool:_allDay                  forKey:allDayKey];
    [aCoder encodeBool:_food                    forKey:foodKey];
    [aCoder encodeObject:_eventID               forKey:eventIDKey];
}

#pragma mark Setters

- (void)setDescription:(NSString *)description
{
    _eventDescription = description;
    [self setAttributedDescriptionWithHTML:_eventDescription];
}

- (void)setAttributedDescriptionWithHTML:(NSString *)html
{
    if (!html || [html isEqual:[NSNull null]]) {
        _attributedDescription = nil;
        return;
    }
    
    // Parse the HTML to construct an attributed string
    // Parsing HTMl must occur on main queue
    __block NSMutableAttributedString *attributedHTML = nil;
    dispatch_sync(dispatch_get_main_queue(), ^{
        attributedHTML = [[[NSAttributedString alloc]initWithData:[html dataUsingEncoding:NSUTF32StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil]mutableCopy];
    });
                  
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
         fontDescriptorAttributes[UIFontDescriptorNameAttribute] = eventDescriptionFontName;
         
         // Create a new font from the attributes
         UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:fontDescriptorAttributes];
         UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:fontSizeModifier * htmlFont.pointSize];
         
         // Configure line/paragraph spacing
         NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
         paragraphStyle.lineSpacing         = lineSpacing;
         paragraphStyle.paragraphSpacing    = paragraphSpacing;
         
         // Add the attributes to attributedHTML to simplify skipping content
         [attributedHTML addAttribute:NSFontAttributeName value:font range:range];
         [attributedHTML addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
         
         // Append the configured attributed string
         [attributedContent appendAttributedString:[attributedHTML attributedSubstringFromRange:range]];
     }];
    
    _attributedDescription = attributedContent;
}

@end

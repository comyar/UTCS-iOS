//
//  UTCSNewsArticle.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSNewsArticle.h"

#import "UIImage+CZTinting.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+CZScaling.h"
#import "NSAttributedString+Trim.h"



#pragma mark - Constants

// NSCoding keys
static NSString * const titleKey                = @"title";
static NSString * const urlKey                  = @"url";
static NSString * const dateKey                 = @"date";
static NSString * const htmlKey                 = @"html";
static NSString * const attributedContentKey    = @"attributedContent";
static NSString * const headerImageKey          = @"headerImage";
static NSString * const headerBlurredImageKey   = @"headerBlurredImage";

// Minimum width of an image in a news article for it to become the header image


// Font to use for a news article's text
static NSString * const articleFont = @"HelveticaNeue-Light";


#pragma mark - UTCSNewsStory Implementation

@implementation UTCSNewsArticle

#pragma mark NSCoding Methods

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        _title              = [aDecoder decodeObjectForKey:titleKey];
        _url                = [aDecoder decodeObjectForKey:urlKey];
        _date               = [aDecoder decodeObjectForKey:dateKey];
        _html               = [aDecoder decodeObjectForKey:htmlKey];
        _attributedContent  = [aDecoder decodeObjectForKey:attributedContentKey];
        _headerImage        = [aDecoder decodeObjectForKey:headerImageKey];
        _headerBlurredImage = [aDecoder decodeObjectForKey:headerBlurredImageKey];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_title                 forKey:titleKey];
    [aCoder encodeObject:_url                   forKey:urlKey];
    [aCoder encodeObject:_date                  forKey:dateKey];
    [aCoder encodeObject:_html                  forKey:htmlKey];
    [aCoder encodeObject:_attributedContent     forKey:attributedContentKey];
    [aCoder encodeObject:_headerImage           forKey:headerImageKey];
    [aCoder encodeObject:_headerBlurredImage    forKey:headerBlurredImageKey];
}

#pragma mark Setters

- (void)setHtml:(NSString *)html
{
    _html = html;
    [self configureNewsStoryWithHTML:_html];
}

#pragma mark Configuration

- (void)configureNewsStoryWithHTML:(NSString *)html
{
    if (!html || [html isEqual:[NSNull null]]) {
        return;
    }
    
    // Parsing HTMl must occur on main queue
    __block NSMutableAttributedString *attributedHTML = nil;
    dispatch_sync(dispatch_get_main_queue(), ^{
        attributedHTML = [[[NSAttributedString alloc]initWithData:[html dataUsingEncoding:NSUTF32StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil]mutableCopy];
    });
    
    if (!attributedHTML) {
        return;
    }
    
    NSMutableAttributedString *attributedContent = [NSMutableAttributedString new];
    
    // Iterate over the attributed string
    [attributedHTML enumerateAttributesInRange:NSMakeRange(0, [attributedHTML length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        // If not an image or some other attachment
        if(!attrs[NSAttachmentAttributeName]) {
            
            // Get the current font in the attributed string
            UIFont *htmlFont = attrs[NSFontAttributeName];
            NSMutableDictionary *fontDescriptorAttributes = [[[htmlFont fontDescriptor]fontAttributes]mutableCopy];
            
            // Change the font in the article
            fontDescriptorAttributes[UIFontDescriptorNameAttribute] = articleFont;
            
            // Create a new font from the attributes
            UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:fontDescriptorAttributes];
            UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:1.5 * htmlFont.pointSize];
            
            // Configure line/paragraph spacing
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineSpacing = 6.0;
            paragraphStyle.paragraphSpacing = 16.0;
            
            // Add the attributes to attributedHTML to simplify skipping content
            [attributedHTML addAttribute:NSFontAttributeName value:font range:range];
            [attributedHTML addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
            
            // Append the configured attributed string to attributedContent
            [attributedContent appendAttributedString:[attributedHTML attributedSubstringFromRange:range]];
            
            // Hack to remove extra spacing before/after bullet points. Leaves (most) other things unaffected
            // TODO: Find better solution
            [attributedContent.mutableString replaceOccurrencesOfString:@"	"
                                                             withString:@" "
                                                                options:NSLiteralSearch
                                                                  range:NSMakeRange(0, [attributedContent.mutableString length])];
        }
    }];
    
    // Remove extra newlines and whitespace
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((\n|\r){2,})" options:0 error:nil];
    [regex replaceMatchesInString:[attributedContent mutableString] options:0 range:NSMakeRange(0, [attributedContent length]) withTemplate:@""];
    
    _attributedContent = [attributedContent attributedStringByTrimming:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

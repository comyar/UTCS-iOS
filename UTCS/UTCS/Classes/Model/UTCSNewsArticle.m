//
//  UTCSNewsArticle.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSNewsArticle.h"
#import "NSAttributedString+Trim.h"


#pragma mark - Constants

// Key for encoding title
static NSString * const titleKey                = @"title";

// Key for encoding url
static NSString * const urlKey                  = @"url";

// Key for encoding data
static NSString * const dateKey                 = @"date";

// Key for encoding html
static NSString * const htmlKey                 = @"html";

// Key for encoding attributedContent
static NSString * const attributedContentKey    = @"attributedContent";

// Key for encoding headerImage
static NSString * const headerImageKey          = @"headerImage";

// Key for encoding headerBlurredImage
static NSString * const headerBlurredImageKey   = @"headerBlurredImage";

// Key for encoding imageURLs
static NSString * const imageURLsKey            = @"imageURLs";


// Space between lines in the article text
static const CGFloat lineSpacing        = 6.0;

// Space between paragraphs in the article text
static const CGFloat paragraphSpacing   = 16.0;

// Amount to increase the parsed font size of articles
static const CGFloat fontSizeModifier   = 1.5;


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
        _imageURLs          = [aDecoder decodeObjectForKey:imageURLsKey];
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
    [aCoder encodeObject:_imageURLs             forKey:imageURLsKey];
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
        
            
            // Create a new font from the attributes
            UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:fontDescriptorAttributes];
            UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:fontSizeModifier* htmlFont.pointSize];
            
            // Configure line/paragraph spacing
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineSpacing      = lineSpacing;
            paragraphStyle.paragraphSpacing = paragraphSpacing;
            
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
    
    // Remove extra newlines and whitespace from within article text
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((\n|\r){2,})" options:0 error:nil];
    [regex replaceMatchesInString:[attributedContent mutableString] options:0 range:NSMakeRange(0, [attributedContent length]) withTemplate:@""];
    
    // Trim leading/trailing whitespace
    _attributedContent = [attributedContent attributedStringByTrimming:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end

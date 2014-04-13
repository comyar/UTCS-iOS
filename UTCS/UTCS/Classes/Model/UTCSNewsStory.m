//
//  UTCSNewsArticle.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/4/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsStory.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+CZTinting.h"

NSString * const UTCSParseNewsStoryTitle    = @"title";
NSString * const UTCSParseNewsStoryDate     = @"date";
NSString * const UTCSParseNewsStoryHTML     = @"text";

NSString * const UTCSNewsStoryCodingTitle               = @"title";
NSString * const UTCSNewsStoryCodingText                = @"text";
NSString * const UTCSNewsStoryCodingDate                = @"date";
NSString * const UTCSNewsStoryCodingHTMl                = @"html";
NSString * const UTCSNewsStoryCodingHeaderImage         = @"headerImage";
NSString * const UTCSNewsStoryCodingHeaderBlurredImage  = @"headerBlurredImage";


static const CGFloat minHeaderImageWidth = 300.0;

#pragma mark - UTCSNewsStory Implementation

@implementation UTCSNewsStory

+ (UTCSNewsStory *)newsStoryWithParseObject:(PFObject *)object
{
    return [[UTCSNewsStory alloc]initWithParseObject:object];
}

- (instancetype)initWithParseObject:(PFObject *)object
{
    if(self = [super init]) {
        _title              = object[UTCSParseNewsStoryTitle];
        _date               = object[UTCSParseNewsStoryDate];
        _html               = object[UTCSParseNewsStoryHTML];
        [self configureNewsStoryWithHTML:_html];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
}

- (void)configureNewsStoryWithHTML:(NSString *)html
{
    if(!html) {
        return;
    }
    
    NSMutableAttributedString *attributedHTML = [[[NSAttributedString alloc]initWithData:[html dataUsingEncoding:NSUTF32StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil]mutableCopy];
    
    __block UIImage *headerImage = nil;
    NSMutableAttributedString *attributedContent = [NSMutableAttributedString new];
    [attributedHTML enumerateAttributesInRange:NSMakeRange(0, [attributedHTML length]) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if(attrs[NSAttachmentAttributeName] && !headerImage) {
            NSTextAttachment *textAttachment = attrs[NSAttachmentAttributeName];
            UIImage *image = textAttachment.image;
            if(textAttachment.fileWrapper.isRegularFile) {
                image = [UIImage imageWithData:textAttachment.fileWrapper.regularFileContents];
            }
            if(image.size.width >= minHeaderImageWidth) {
                headerImage = image;
            }
        } else {
            UIFont *htmlFont = attrs[NSFontAttributeName];
            NSMutableDictionary *fontDescriptorAttributes = [[[htmlFont fontDescriptor]fontAttributes]mutableCopy];
            fontDescriptorAttributes[UIFontDescriptorNameAttribute] = @"HelveticaNeue-Light";
            UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:fontDescriptorAttributes];
            UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:1.6 * htmlFont.pointSize];
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineSpacing = 6.0;
            paragraphStyle.paragraphSpacing = 16.0;
            
            [attributedHTML addAttribute:NSFontAttributeName value:font range:range];
            [attributedHTML addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
            [attributedContent appendAttributedString:[attributedHTML attributedSubstringFromRange:range]];
            [attributedContent.mutableString replaceOccurrencesOfString:@"	"
                                                             withString:@" "
                                                                options:NSLiteralSearch
                                                                  range:NSMakeRange(0, [attributedContent.mutableString length])];
        }
    }];
    
    self.headerImage = [headerImage tintedImageWithColor:[UIColor colorWithWhite:0.11 alpha:0.73] blendingMode:kCGBlendModeOverlay];
    self.blurredHeaderImage = [headerImage applyDarkEffect];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((\n|\r){2,})" options:0 error:nil];
    [regex replaceMatchesInString:[attributedContent mutableString] options:0 range:NSMakeRange(0, [attributedContent length]) withTemplate:@""];
    
    self.attributedContent = attributedContent;
}

@end

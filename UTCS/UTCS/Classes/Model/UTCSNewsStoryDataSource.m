//
//  UTCSNewsStoryDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

// Models
#import "UTCSNewsStory.h"
#import "UTCSNewsStoryDataSource.h"

// Views
#import "UTCSTableViewCell.h"

// Categories
#import "UIImage+CZTinting.h"
#import "UIImage+CZScaling.h"
#import "UIImage+ImageEffects.h"


#pragma mark - Constants

static const CGFloat minHeaderImageWidth = 300.0;

typedef void (^ UTCSNewStoryManagerCompletion) (NSArray *newsStories, NSError *error);

NSString * const UTCSParseClassNews                     = @"NewsStory";

const NSTimeInterval kEarliestTimeIntervalForNews       = INT32_MIN;


#pragma mark - UTCSNewsStoryDataSource Class Extension

@interface UTCSNewsStoryDataSource ()

// Overidden newsStories property
@property (nonatomic) NSArray *newsStories;

@end


#pragma mark - UTCSNewsStoryDataSource Implementation

@implementation UTCSNewsStoryDataSource

- (UTCSTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSTableViewCell"];
    if(!cell) {
        cell = [[UTCSTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSTableViewCell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryView = ({
            UIImage *image = [[UIImage imageNamed:@"rightArrow"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.tintColor = [UIColor colorWithWhite:1.0 alpha:0.5];
            imageView;
        });
//        cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        cell.textLabel.numberOfLines = 4;
//        cell.textLabel.textColor = [UIColor whiteColor];
        
//        cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        cell.detailTextLabel.numberOfLines = 4;
//        cell.detailTextLabel.textColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    
    UTCSNewsStory *newsStory = self.newsStories[indexPath.row];
    cell.textLabel.text = newsStory.title;
    cell.detailTextLabel.text = [newsStory.attributedContent string];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsStories count];
}

- (void)updateNewsStoriesWithCompletion:(void (^)(void))completion
{
    [self newsStoriesWithCompletion:^(NSArray *newsStories, NSError *error) {
        if(newsStories) {
            self.newsStories = newsStories;
        }
        if(completion) {
            completion();
        }
    }];
}

- (void)newsStoriesWithCompletion:(UTCSNewStoryManagerCompletion)completion
{
    PFQuery *query = [PFQuery queryWithClassName:UTCSParseClassNews];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:UTCSParseNewsStoryDate greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:kEarliestTimeIntervalForNews]];
    
    [query findObjectsInBackgroundWithBlock: ^ (NSArray *objects, NSError *error) {
        NSArray *sortedNewsStories = nil;
        NSMutableArray *newsStories = [NSMutableArray new];
        if(objects) {
            for(PFObject *object in objects) {
                UTCSNewsStory *newsStory = [UTCSNewsStory newsStoryWithParseObject:object];
                if([self setAttributedContentForNewsStory:newsStory]) {
                    [newsStories addObject:newsStory];
                }
            }
            
            sortedNewsStories = [newsStories sortedArrayUsingComparator: ^ NSComparisonResult(id obj1, id obj2) {
                UTCSNewsStory *story1 = (UTCSNewsStory *)obj1;
                UTCSNewsStory *story2 = (UTCSNewsStory *)obj2;
                return [story2.date compare:story1.date];
            }];
        }
        
        completion(sortedNewsStories, error);
    }];
}

- (BOOL)setAttributedContentForNewsStory:(UTCSNewsStory *)newsStory
{
    
    NSMutableAttributedString *attributedHTML = [[[NSAttributedString alloc]initWithData:[newsStory.html dataUsingEncoding:NSUTF32StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil]mutableCopy];
    
    if(!attributedHTML) {
        return NO;
    }
    
    
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
            [attributedContent.mutableString replaceOccurrencesOfString:@"	" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [attributedContent.mutableString length])];
        }
    }];
    
    newsStory.headerImage = [headerImage tintedImageWithColor:[UIColor colorWithWhite:0.11 alpha:0.73] blendingMode:kCGBlendModeOverlay];
    newsStory.blurredHeaderImage = [headerImage applyDarkEffect];

    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((\n|\r){2,})" options:0 error:nil];
    [regex replaceMatchesInString:[attributedContent mutableString] options:0 range:NSMakeRange(0, [attributedContent length]) withTemplate:@""];
    
    newsStory.attributedContent = attributedContent;
    
    return YES;
}


@end
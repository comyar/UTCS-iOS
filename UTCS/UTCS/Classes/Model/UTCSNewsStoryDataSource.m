//
//  UTCSNewsStoryDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsStoryDataSource.h"
#import "UTCSNewsStory.h"

#import "UIImage+CZScaling.h"

typedef void (^ UTCSNewStoryManagerCompletion) (NSArray *newsStories, NSError *error);

NSString * const cellIdentifier                         = @"UTCSNewsTableViewCell";

NSString * const UTCSParseClassNews                     = @"NewsStory";

NSString * const UTCSNewsStoryTitleFontAttribute        = @"UTCSNewsStoryTitleFontAttribute";
NSString * const UTCSNewsStoryTitleFontColorAttribute   = @"UTCSNewsStoryTitleFontColorAttribute";

NSString * const UTCSNewsStoryDateFontAttribute         = @"UTCSNewsStoryDateFontAttribute";
NSString * const UTCSNewsStoryDateFontColorAttribute    = @"UTCSNewsStoryDateFontColorAttribute";

NSString * const UTCSNewsStoryTextFontAttribute         = @"UTCSNewsStoryTextFontAttribute";
NSString * const UTCSNewsStoryTextFontColorAttribute    = @"UTCSNewsStoryTextFontColorAttribute";

NSString * const UTCSNewsStoryParagraphLineSpacing      = @"UTCSNewsStoryParagraphLineSpacing";

const NSTimeInterval kEarliestTimeIntervalForNews   = INT32_MIN;


@implementation UTCSNewsStoryDataSource

- (instancetype)init
{
    if(self = [super init]) {
        
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UTCSNewsStory *newsStory = self.newsStories[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = newsStory.title;
    cell.detailTextLabel.text = newsStory.text;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.newsStories count];
}

- (void)updateNewsStories:(void (^)(void))completion
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
                [self configureNewsStory:newsStory];
                [newsStories addObject:newsStory];
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


- (void)downloadImagesForJSON:(NSArray *)JSON completion:(void (^)(UIImage *header, NSDictionary *images))completion
{
    NSMutableArray *imageURLs = [NSMutableArray new];
    for(NSDictionary *content  in JSON) {
        if([content[@"type"] isEqualToString:@"image"]) {
            [imageURLs addObject:content[@"src"]];
        }
    }
    
    __block int count = 0;
    __block UIImage *headerImage = nil;
    NSMutableDictionary *images = [NSMutableDictionary new];
    for(NSString *url in imageURLs) {
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(data) {
                UIImage *image = [UIImage imageWithData:data];
                if(!headerImage && image.size.width > 300) {
                    headerImage = image;
                } else {
                    images[url] = image;
                }
            }
            count++;
            if(count == [imageURLs count]) {
                completion(headerImage, images);
            }
        }];
    }
}

- (void)configureNewsStory:(UTCSNewsStory *)newsStory
{
    
    NSArray *json = [NSJSONSerialization JSONObjectWithData:[newsStory.json dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:NSJSONReadingAllowFragments
                                                      error:nil];
    if(json) {
        
        [self downloadImagesForJSON:json completion:^(UIImage *header, NSDictionary *images) {
            
            if(header) {
                newsStory.headerImage = header;
            }
            
            NSDictionary *fonts = @{@"normal":@"Georgia",
                                    @"header":@"Georgia-Bold",
                                    @"subheader":@"Georgia-Italic",
                                    @"strong":@"Georgia-Bold"};
            
            NSMutableString *storyText = [NSMutableString new];
            NSMutableAttributedString *attributedContent = [NSMutableAttributedString new];
            
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineSpacing = 8.0;
            
            for(NSDictionary *content in json) {
                if([content[@"type"] isEqualToString:@"text"]) {
                    NSString *fontType = content[@"font"];
                    NSString *text  = content[@"content"];
                    [storyText appendString:text];
                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:text];
                    [attributedText addAttribute:NSFontAttributeName
                                           value:[UIFont fontWithName:fonts[fontType] size:18]
                                           range:NSMakeRange(0, [attributedText length])];
                    [attributedText addAttribute:NSParagraphStyleAttributeName
                                           value:paragraphStyle
                                           range:NSMakeRange(0, [attributedText length])];
                    [attributedContent appendAttributedString:attributedText];
                } else if([content[@"type"] isEqualToString:@"link"]) {

                    
                } else if([content[@"type"] isEqualToString:@"image"]) {
                    UIImage *image = images[content[@"src"]];
                    if(image) {
                        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
                        paragraphStyle.alignment = NSTextAlignmentCenter;
                        
                        NSTextAttachment *textAttachment = [NSTextAttachment new];
                        textAttachment.image = image;
                        
                        NSMutableAttributedString *imageString = [[NSAttributedString attributedStringWithAttachment:textAttachment]mutableCopy];
                        [imageString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [imageString length])];
                        
                        [attributedContent appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
                        [attributedContent appendAttributedString:imageString];
                        [attributedContent appendAttributedString:[[NSAttributedString alloc]initWithString:@"\n"]];
                    }
                }
            }
            
            newsStory.text = storyText;
            newsStory.attributedContent = attributedContent;
        }];
    }
}



@end

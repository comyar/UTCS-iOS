//
//  UTCSNewsDetailViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/5/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSNewsDetailViewController.h"
#import "UIView+CZPositioning.h"
#import "UIColor+UTCSColors.h"
#import "UITextView+CZTextViewHeight.h"
#import "UTCSNewsStory.h"
#import "UIImageView+WebCache.h"

const CGFloat kParagraphLineSpacing = 5.0;

@interface UTCSNewsDetailViewController ()

@property (strong, nonatomic) NSMutableDictionary       *images;

@property (strong, nonatomic) NSMutableArray            *imageViewPool;

@property (strong, nonatomic) UIScrollView              *scrollView;

@property (strong, nonatomic) UITextView                *contentTextView;

@property (strong, nonatomic) NSMutableAttributedString *attributedText;

@end

@implementation UTCSNewsDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        self.scrollView.alwaysBounceVertical = YES;
        self.contentTextView = [[UITextView alloc]initWithFrame:CGRectZero];
        self.contentTextView.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor utcsBurntOrangeColor]};
        self.contentTextView.dataDetectorTypes = UIDataDetectorTypeLink | UIDataDetectorTypePhoneNumber;
        self.contentTextView.scrollEnabled = NO;
        self.contentTextView.editable = NO;
    }
    return self;
}

#pragma mark UIViewController Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.frame = self.view.bounds;
    [self.view addSubview:self.scrollView];
    
    self.contentTextView.frame = CGRectMake(8.0, self.scrollView.x, self.scrollView.width - 16.0, self.scrollView.height);
    [self.scrollView addSubview:self.contentTextView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scrollView scrollRectToVisible:CGRectMake(0.0, 0.0, self.view.width, 1.0) animated:NO];
}

- (void)updateWithNewsStory:(UTCSNewsStory *)newsStory
{
    self.title = [NSDateFormatter localizedStringFromDate:newsStory.date
                                                dateStyle:NSDateFormatterMediumStyle
                                                timeStyle:NSDateFormatterNoStyle];
    
    
    
    self.attributedText = [NSMutableAttributedString new];
    
    NSString *titleText = [NSString stringWithFormat:@"%@\n", newsStory.title];
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc]initWithString:titleText attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline], NSForegroundColorAttributeName: [UIColor blackColor]}];
    [self.attributedText appendAttributedString:titleAttributedString];
    
    NSString *dateText = [NSString stringWithFormat:@"%@\n\n", [NSDateFormatter localizedStringFromDate:newsStory.date
                                                                                              dateStyle:NSDateFormatterLongStyle
                                                                                              timeStyle:NSDateFormatterNoStyle]];
    
    NSMutableAttributedString *dateAttributedString = [[NSMutableAttributedString alloc]initWithString:dateText attributes:@{NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote], NSForegroundColorAttributeName: [UIColor utcsBurntOrangeColor]}];
    [self.attributedText appendAttributedString:dateAttributedString];
    
    NSMutableAttributedString *contentAttributedString = [[NSMutableAttributedString alloc]initWithData:[newsStory.html dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute:[NSNumber numberWithInt:NSUTF8StringEncoding]} documentAttributes:nil error:nil];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = kParagraphLineSpacing;
    
    [self.attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.attributedText length])];
    [self.attributedText appendAttributedString:contentAttributedString];
    
    self.contentTextView.attributedText = self.attributedText;
    self.contentTextView.height = [self.contentTextView heightWithText];
    self.scrollView.contentSize = self.contentTextView.bounds.size;
}

- (void)downloadImagesForNewStory:(UTCSNewsStory *)newsStory withCompletion:(void(^)(void))completion
{
    NSMutableArray *imageURLs = [NSMutableArray new];
    for(NSDictionary *content in newsStory.jsonContent) {
        NSString *imageURL = content[@"src"];
        if(imageURL) {
            [imageURLs addObject:imageURL];
        }
    }
    NSLog(@"%ld images to download", [imageURLs count]);
    
    __block NSInteger numImagesDownloaded = 0;
    __block NSInteger numImagesToDownload = [imageURLs count];
    NSInteger count = [imageURLs count];
    for(NSInteger i = 0; i < count; ++i) {
        NSLog(@"%ld image number", i);
        if(i + 1 > [self.imageViewPool count]) {
            NSLog(@"adding imageview to pool");
            [self.imageViewPool addObject:[UIImageView new]];
        }
        
        UIImageView *imageView = self.imageViewPool[i];
        NSURL *imageURL = [NSURL URLWithString:imageURLs[i]];
        NSLog(@"%@", imageURL);
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(data) {
                NSLog(@"image data");
                imageView.image = [UIImage imageWithData:data];
            }
            numImagesDownloaded++;
            if(numImagesDownloaded >= numImagesToDownload) {
                completion();
            }
        }];
    }
    
    if(numImagesToDownload == 0) {
        completion();
    }
}

#pragma mark Overridden Setters

- (void)setNewsStory:(UTCSNewsStory *)newsStory
{
    _newsStory = newsStory;
    [self updateWithNewsStory:newsStory];
//    [self downloadImagesForNewStory:newsStory withCompletion: ^ {
//        NSLog(@"finished downloading all images");
//        [self updateWithNewsStory:newsStory];
//    }];
}

@end

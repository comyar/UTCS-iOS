//
//  UTCSEventsDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSEventsManager.h"
#import "UTCSEvent.h"
#import "UTCSEventTableViewCell.h"


typedef void (^ UTCSEventManagerCompletion) (NSArray *events, NSError *error);


const NSTimeInterval kEarliestTimeIntervalForEvents           = -86400;

NSString * const UTCSParseClassEvent                        = @"Event";


@interface UTCSEventsManager ()
@property (nonatomic) NSArray *events;
@property (nonatomic) NSDateFormatter *monthDateFormatter;
@property (nonatomic) NSDateFormatter *dayDateFormatter;
@end


@implementation UTCSEventsManager

- (instancetype)init
{
    if(self = [super init]) {
        self.monthDateFormatter = ({
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"MMM";
            formatter;
        });
        
        self.dayDateFormatter = ({
            NSDateFormatter *formatter = [NSDateFormatter new];
            formatter.dateFormat = @"d";
            formatter;
        });
    }
    return self;
}

- (UTCSEventTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UTCSEventTableViewCell"];
    if(!cell) {
        cell = [[UTCSEventTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UTCSEventTableViewCell"];
    }
    
    UTCSEvent *event = self.events[indexPath.row];
    cell.dayLabel.text = [self.dayDateFormatter stringFromDate:event.startDate];
    
    
    cell.textLabel.text = event.name;
    cell.detailTextLabel.text = [NSDateFormatter localizedStringFromDate:event.startDate dateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterShortStyle];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.events count];
}

- (void)updateEventsWithCompletion:(void (^)(void))completion
{
    [self eventsWithCompletion:^(NSArray *events, NSError *error) {
        if(events) {
            self.events = events;
        }
        if(completion) {
            completion();
        }
    }];
}

- (void)eventsWithCompletion:(UTCSEventManagerCompletion)completion
{
    PFQuery *query = [PFQuery queryWithClassName:UTCSParseClassEvent];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query whereKey:UTCSParseEventEndDate greaterThanOrEqualTo:[NSDate dateWithTimeIntervalSinceNow:kEarliestTimeIntervalForEvents]];
    
    [query findObjectsInBackgroundWithBlock: ^ (NSArray *objects, NSError *error) {
        NSArray *sortedEvents = nil;
        NSMutableArray *events = [NSMutableArray new];
        if(objects) {
            for(PFObject *object in objects) {
                UTCSEvent *event = [UTCSEvent eventWithParseObject:object];
                [self setAttributedDescriptionForEvent:event];
                [events addObject:event];
            }
            
            sortedEvents = [events sortedArrayUsingComparator: ^ NSComparisonResult(id obj1, id obj2) {
                UTCSEvent *event1 = (UTCSEvent *)obj1;
                UTCSEvent *event2 = (UTCSEvent *)obj2;
                return [event1.startDate compare:event2.startDate];
            }];
        }
        
        completion(sortedEvents, error);
    }];

}

- (void)setAttributedDescriptionForEvent:(UTCSEvent *)event
{
    NSMutableAttributedString *attributedHTML = [[[NSAttributedString alloc]initWithData:[event.HTMLDescription dataUsingEncoding:NSUTF32StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil]mutableCopy];
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
            fontDescriptorAttributes[UIFontDescriptorNameAttribute] = @"TimesNewRomanPSMT";
            UIFontDescriptor *fontDescriptor = [UIFontDescriptor fontDescriptorWithFontAttributes:fontDescriptorAttributes];
            UIFont *font = [UIFont fontWithDescriptor:fontDescriptor size:1.5 * htmlFont.pointSize];
            NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
            paragraphStyle.lineSpacing = 6.0;
            paragraphStyle.paragraphSpacing = 16.0;
             
            [attributedHTML addAttribute:NSFontAttributeName value:font range:range];
            [attributedHTML addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
            [attributedContent appendAttributedString:[attributedHTML attributedSubstringFromRange:range]];
     }];

    event.attributedDescription = attributedContent;
}

@end

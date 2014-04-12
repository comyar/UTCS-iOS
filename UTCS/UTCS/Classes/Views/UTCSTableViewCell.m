//
//  UTCSTableViewCell.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSTableViewCell.h"

static const CGFloat animationDuration = 0.3;

@interface UTCSTableViewCell ()
@property (nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;
@end

@implementation UTCSTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.longPressGestureRecognizer = ({
            UILongPressGestureRecognizer *gestureRecognizer = [UILongPressGestureRecognizer new];
            [gestureRecognizer addTarget:self action:@selector(didRecognizeLongPressGesture:)];
            gestureRecognizer.cancelsTouchesInView = NO;
            gestureRecognizer.minimumPressDuration = 0.1;
            gestureRecognizer.delegate = self;
            gestureRecognizer;
        });
        [self.contentView addGestureRecognizer:self.longPressGestureRecognizer];
    }
    return self;
}

- (void)didRecognizeLongPressGesture:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self bounceContentView:YES];
    } else if(gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
              gestureRecognizer.state == UIGestureRecognizerStateFailed ||
              gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self bounceContentView:NO];
    }
}
    
- (void)bounceContentView:(BOOL)down
{
    self.contentView.transform = (down)? CGAffineTransformMakeScale(1.0, 1.0) : CGAffineTransformMakeScale(0.925, 0.925);
    [UIView animateWithDuration:animationDuration/3.0 animations:^{
        self.contentView.transform = (down)? CGAffineTransformMakeScale(0.9, 0.9) : CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:animationDuration/3.0 animations:^{
            self.contentView.transform = (down)? CGAffineTransformMakeScale(0.95, 0.95) : CGAffineTransformMakeScale(0.975, 0.975);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animationDuration/3.0 animations:^{
                self.contentView.transform = (down)? CGAffineTransformMakeScale(0.925, 0.925) : CGAffineTransformMakeScale(1.0, 1.0);
            }];
        }];
    }];
    
    [UIView animateWithDuration:animationDuration animations:^{
        self.contentView.alpha = (down)? 0.5 : 1.0;
    }];
}

#pragma mark UIGestureRecognizerDelegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

@end

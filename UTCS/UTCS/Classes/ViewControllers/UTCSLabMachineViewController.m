//
//  UTCSLabMachineViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/22/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabMachineViewController.h"
#import "UIView+CZPositioning.h"
#import "UTCSLabMachine.h"
#import "UTCSParallaxBlurHeaderScrollView.h"


#pragma mark - UTCSLabMachineViewController Class Extension

@interface UTCSLabMachineViewController ()

@property (nonatomic) UIView            *backgroundContainer;

@property (nonatomic) UTCSLabView       *labView;



@end


#pragma mark - UTCSLabMachineViewController Implementation

@implementation UTCSLabMachineViewController

- (instancetype)initWithLayout:(UTCSLabViewLayout *)layout
{
    if (self = [super initWithNibName:nil bundle:nil]) {
        _layout = layout;
        
        
        self.backgroundContainer = [[UIView alloc]initWithFrame:self.view.bounds];
        self.backgroundContainer.clipsToBounds = YES;
        
        _backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.clipsToBounds = NO;
        
        [self.backgroundContainer addSubview:self.backgroundImageView];
        [self.view addSubview:self.backgroundContainer];

        
        self.labView = [[UTCSLabView alloc]initWithFrame:CGRectZero layout:self.layout];
        self.labView.frame = CGRectMake(0.0, 44.0, self.view.width, self.view.height - 44.0);
        self.labView.backgroundColor = [UIColor clearColor];
        self.labView.alpha = 0.0;
        self.labView.dataSource = self;
        [self.view addSubview:self.labView];
        
        
        self.shimmeringView = [[FBShimmeringView alloc]initWithFrame:CGRectZero];
        self.shimmeringView.contentView = ({
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
            label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:36];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.numberOfLines = 0;
            label;
        });
        
        
        
        
        [self.labView prepareLayout];
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.backgroundImageView.frame = self.view.bounds;
    
    [self.labView invalidateLayout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    _imageOffset = imageOffset;
    
    CGRect frame = self.backgroundContainer.bounds;
    CGRect offsetFrame = CGRectOffset(frame, _imageOffset.x, _imageOffset.y);
    self.backgroundImageView.frame = offsetFrame;
}

- (void)setMachines:(NSDictionary *)machines
{
    _machines = machines;
    [self.labView invalidateLayout];
    [self.labView reloadData];
    if (_machines) {
        [UIView animateWithDuration:0.3 animations:^{
            self.labView.alpha = 1.0;
        }];
    }
}

#pragma mark UTCSLabViewDataSource Methods

- (UTCSLabMachineView *)labView:(UTCSLabView *)labView machineViewForIndexPath:(NSIndexPath *)indexPath name:(NSString *)name
{
    UTCSLabMachineView *machineView = [labView dequeueMachineViewForIndexPath:indexPath];
    UTCSLabMachine *machine = self.machines[name];
    if (!machine) {
        machineView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    } else {
        if (![[machine.status lowercaseString] isEqualToString:@"up"]) {
            machineView.backgroundColor= [UIColor colorWithWhite:0.5 alpha:0.5];
        } else if (machine.occupied) {
            machineView.backgroundColor = [UIColor colorWithRed:0.888 green:0.146 blue:0.020 alpha:1.000];
        } else {
            machineView.backgroundColor = [UIColor colorWithRed:0.324 green:0.935 blue:0.018 alpha:1.000];
        }
    }
    return machineView;
}

@end

//
//  UTCSLabsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/28/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsViewController.h"
#import "UTCSMenuButton.h"
#import "UIImage+ImageEffects.h"

@interface UTCSLabsViewController ()
@property (nonatomic) UIImageView               *backgroundImageView;
@property (nonatomic) UTCSMenuButton            *menuButton;
@end

@implementation UTCSLabsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    self.backgroundImageView.image = [[UIImage imageNamed:@"menuBackground"]applyDarkEffect];
    [self.view addSubview:self.backgroundImageView];
    
    // Menu Button
    self.menuButton = [[UTCSMenuButton alloc]initWithFrame:CGRectMake(2, 8, 56, 32)];
    [self.view addSubview:self.menuButton];
}

@end

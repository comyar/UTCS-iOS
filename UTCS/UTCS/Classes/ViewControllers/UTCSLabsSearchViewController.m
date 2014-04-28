//
//  UTCSLabsSearchViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#import "UTCSLabsSearchViewController.h"

@interface UTCSLabsSearchViewController ()
@property (nonatomic) CAShapeLayer *searchBarLineLayer;
@property (nonatomic) UISearchBar *searchBar;
@end

@implementation UTCSLabsSearchViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        _searchController = [UTCSLabsDataSourceSearchController new];
        
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuButton.hidden = YES;
    
    
    self.searchBar = ({
        UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0.0, 44.0, self.view.width, 64.0)];
        searchBar.backgroundImage = [UIImage new];
        searchBar.placeholder = @"Search Labs";
        searchBar.scopeButtonTitles = @[@"Third Floor", @"Basement"];
        searchBar.scopeBarBackgroundImage = [UIImage new];
        searchBar.tintColor = [UIColor whiteColor];
        searchBar.searchTextPositionAdjustment = UIOffsetMake(8.0, 0.0);
        [searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"searchBarBackground"]
                                        forState:UIControlStateNormal];
        searchBar;
    });
    
    self.searchBarLineLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.path = [UIBezierPath bezierPathWithRect:CGRectMake(32.0, 88.0, self.searchBar.width - 64.0, 0.25)].CGPath;
        layer.strokeColor = [UIColor colorWithWhite:1.0 alpha:0.5].CGColor;
        layer.strokeStart = 0.0;
        layer.strokeEnd = 1.0;
        layer.lineWidth = 0.5;
        layer;
    });
    
    [self.view.layer addSublayer:self.searchBarLineLayer];
    
    [self.view addSubview:self.searchBar];
    
    _searchController.searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.searchBar
                                                                                 contentsController:self];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

@end

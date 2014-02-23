//
//  UTCSLabsViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 2/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabsViewController.h"
#import "UTCSLabsCollectionViewCell.h"

// Constants
static NSString *cellIdentifier = @"LabsCollectionViewCell";


#pragma mark - UTCSLabsViewController Class Extension

@interface UTCSLabsViewController ()

//
@property (strong, nonatomic) UINavigationBar   *navigationBar;

//
@property (strong, nonatomic) UISegmentedControl *labSegmentedControl;

//
@property (strong, nonatomic) UICollectionView  *thirdFloorCollectionView;

//
@property (strong, nonatomic) UICollectionView  *basementCollectionView;

//
@property (strong, nonatomic) UIImage           *workstationImage;

@end


#pragma mark - UTCSLabsViewController Implementation

@implementation UTCSLabsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.view.backgroundColor = [UIColor whiteColor];
        self.workstationImage = [[UIImage imageNamed:@"labs"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
	self.thirdFloorCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0, 60.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 60.0) collectionViewLayout:layout];
    [self.thirdFloorCollectionView registerNib:[UINib nibWithNibName:@"UTCSLabsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    self.thirdFloorCollectionView.backgroundColor = [UIColor whiteColor];
    self.thirdFloorCollectionView.dataSource = self;
    self.thirdFloorCollectionView.delegate = self;
    [self.view addSubview:self.thirdFloorCollectionView];
    
    self.basementCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0.0, 60.0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 60.0) collectionViewLayout:layout];
    [self.basementCollectionView registerNib:[UINib nibWithNibName:@"UTCSLabsCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellIdentifier];
    self.basementCollectionView.backgroundColor = [UIColor whiteColor];
    self.basementCollectionView.dataSource = self;
    self.basementCollectionView.delegate = self;
    self.basementCollectionView.hidden = YES;
    [self.view addSubview:self.basementCollectionView];
    
    self.navigationBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 60)];
    [self.view addSubview:self.navigationBar];
    
    self.labSegmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"Third Floor", @"Basement"]];
    [self.labSegmentedControl addTarget:self action:@selector(valueDidChangeForSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.labSegmentedControl.selectedSegmentIndex = 0;
    
    UINavigationItem *navigationItem = [UINavigationItem new];
    navigationItem.titleView = self.labSegmentedControl;
    [self.navigationBar pushNavigationItem:navigationItem animated:YES];
}

- (void)valueDidChangeForSegmentedControl:(UISegmentedControl *)segmentedControl
{
    if(segmentedControl.selectedSegmentIndex == 0) {
        self.thirdFloorCollectionView.hidden = NO;
        self.basementCollectionView.hidden = YES;
    } else if(segmentedControl.selectedSegmentIndex == 1) {
        self.thirdFloorCollectionView.hidden = YES;
        self.basementCollectionView.hidden = NO;
    }
}

#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 50;
}

- (UTCSLabsCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UTCSLabsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageView.image = self.workstationImage;
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(44.0, 44.0);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(16.0, 16.0, 16.0, 16.0);
}

@end

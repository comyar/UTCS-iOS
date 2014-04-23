//
//  UTCSCardCollectionViewController.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSCardCollectionViewController.h"

@interface UTCSCardCollectionViewController ()


@property (nonatomic) UICollectionViewFlowLayout    *flowLayout;
@property (nonatomic) UICollectionView              *collectionView;
@property (nonatomic) UIPanGestureRecognizer        *panGestureRecognizer;
@property (nonatomic) NSMutableArray                *cardViewControllers;

@end

@implementation UTCSCardCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.backgroundImageView.image = [UIImage imageNamed:@"diskQuotaBackground"];
        
        self.cardViewControllers = [NSMutableArray new];
        
        self.flowLayout = [UICollectionViewFlowLayout new];
        self.flowLayout.minimumInteritemSpacing = 0.0;
        self.flowLayout.minimumLineSpacing = 0.0;
        
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.flowLayout];
        self.collectionView.alwaysBounceHorizontal = YES;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.pagingEnabled = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.frame = CGRectMake(0.0, 0.5 * self.view.height, self.view.width, 0.5 * self.view.height);
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UTCSCardCollectionViewCell"];
    [self.view addSubview:self.collectionView];
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didRecognizePanGesture:)];
}

- (void)didRecognizePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        static CGSize initial;
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        CGFloat normalizedDelta = - (0.2 * translation.y) / self.view.height;
        
        
        
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            initial = self.collectionView.bounds.size;
            
        } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            
            
            
            self.collectionView.height = MIN(self.view.height, MAX(0.2 * self.view.height,
                                                                   (1.0 + normalizedDelta) * self.collectionView.height));
            self.collectionView.width = MAX(self.view.width, (1.0 + normalizedDelta) * self.collectionView.width);
            self.collectionView.y = self.view.height - self.collectionView.height;
            
            [self.collectionView.collectionViewLayout invalidateLayout];
            
        } else {
            
            
            if (self.collectionView.height >= 0.6 * self.view.width) {
                [UIView animateWithDuration:0.3 animations:^{
                    [UIView animateWithDuration:0.3 animations:^{
                        self.collectionView.height = self.view.height;
                        self.collectionView.y = 0.0;
                    }];
                }];
            } else {
                [UIView animateWithDuration:0.3 animations:^{
                    self.collectionView.height = 0.5 * self.view.height;
                    self.collectionView.y = 0.5 * self.view.height;
                }];
            }
            
        }
         
    }
}

- (void)addChildViewControllerAsCard:(UIViewController *)viewController
{
    [self.cardViewControllers addObject:viewController];
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.cardViewControllers count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UTCSCardCollectionViewCell" forIndexPath:indexPath];

    
    UIViewController *viewController = self.cardViewControllers[indexPath.row];
    [viewController.view removeFromSuperview];
    viewController.view.frame = cell.bounds;
    [cell.contentView addSubview:viewController.view];
    
    cell.clipsToBounds = YES;
    cell.backgroundColor = (indexPath.row % 2)? [UIColor redColor] : [UIColor greenColor];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0.14 * collectionView.height, 0.0, 0.0, 0.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(0.48 * collectionView.width, 0.86 * collectionView.height);
}


@end

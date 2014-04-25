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
        self.collectionView.alwaysBounceVertical = NO;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        self.collectionView.backgroundColor = [UIColor clearColor];
        self.collectionView.pagingEnabled = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        
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
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)didRecognizePanGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panGestureRecognizer) {
        
        static CGRect initial;
        
        CGPoint translation = [gestureRecognizer translationInView:self.view];
        NSLog(@"%f", translation.y);
        
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
            initial = self.collectionView.frame;
        } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGFloat height = initial.size.height - translation.y;
            self.collectionView.height = MAX(0.25 * self.view.height, MIN(1.1 * self.view.height, height));
            self.collectionView.width = 2.0 * (self.collectionView.height / self.view.height) * self.view.width;
            self.collectionView.y = self.view.height - self.collectionView.height;
            self.collectionView.contentSize = CGSizeMake(self.collectionView.width, self.collectionView.height);
            [self.collectionView.collectionViewLayout invalidateLayout];
        } else {
            
            CGPoint velocity = [gestureRecognizer velocityInView:self.view];
            CGRect frame = CGRectMake(0.0, 0.0, 2.0 * self.view.width, self.view.height);
            
            if (velocity.y > 100) {
                frame = CGRectMake(0.0, 0.5 * self.view.height, self.view.width, 0.5 * self.view.height);
            }
            
            [UIView animateWithDuration:0.3 animations:^{
                self.collectionView.frame = frame;
                [self.collectionView.collectionViewLayout invalidateLayout];
            } completion:^(BOOL finished) {
                [self.collectionView.collectionViewLayout invalidateLayout];
            }];
        }
         
    }
}

- (void)addChildViewControllerAsCard:(UIViewController *)viewController
{
    viewController.view.layer.cornerRadius = 4.0;
    viewController.view.layer.masksToBounds = YES;
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    
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
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(0.49 * collectionView.width, 0.98 * collectionView.height);
}


@end

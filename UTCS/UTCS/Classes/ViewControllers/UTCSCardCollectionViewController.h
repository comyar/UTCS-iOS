//
//  UTCSCardCollectionViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/23/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSContentViewController.h"

@interface UTCSCardCollectionViewController : UTCSContentViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

- (void)addChildViewControllerAsCard:(UIViewController *)viewController;

@end

//
//  UTCSLabsViewController.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UTCSMenuViewControllerDelegate.h"

/**
 */
@interface UTCSLabsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

//
@property (strong, nonatomic, readonly) UINavigationBar *navigationBar;

@end

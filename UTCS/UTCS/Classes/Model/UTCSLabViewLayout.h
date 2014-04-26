//
//  UTCSLabsCollectionViewLayout.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import UIKit;
@class UTCSLabView;
@class UTCSLabViewLayoutAttributes;

@interface UTCSLabViewLayout : NSObject

- (instancetype)initWithFilename:(NSString *)filename;
- (void)prepareLayoutForLabView:(UTCSLabView *)labView;

- (UTCSLabViewLayoutAttributes *)layoutAttributesForIndexPath:(NSIndexPath *)indexPath;
- (UTCSLabViewLayoutAttributes *)layoutAttributesForLabMachineName:(NSString *)labMachineName;

@property (nonatomic, readonly) NSInteger numberOfLabMachines;

@end

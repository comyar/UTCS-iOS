/*
//
//  UTCSLabsCollectionViewLayout.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/25/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSLabViewLayout.h"
#import "UTCSLabView.h"
#import "UTCSLabViewLayoutAttributes.h"

@interface UTCSLabViewLayout ()

@property (nonatomic) NSDictionary  *meta;
@property (nonatomic) NSDictionary  *values;
@property (nonatomic) NSDictionary  *layoutAttributes;
@property (nonatomic) NSArray       *indexPathLayoutAttributes;
@end


@implementation UTCSLabViewLayout

- (instancetype)initWithFilename:(NSString *)filename
{
    if (self = [super init]) {
        NSString *path = [[NSBundle mainBundle]pathForResource:filename ofType:@"plist"];
        NSDictionary *layoutDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
        
        _meta   = layoutDictionary[@"meta"];
        _values = layoutDictionary[@"values"];
        _numberOfLabMachines = [_values count];
        
    }
    return self;
}

- (NSString *)labMachineNameForIndexPath:(NSIndexPath *)indexPath
{
    UTCSLabViewLayoutAttributes *layoutAttribute = [self layoutAttributesForIndexPath:indexPath];
    for (NSString *key in self.layoutAttributes) {
        if ([layoutAttribute isEqual:self.layoutAttributes[key]]) {
            return key;
        }
    }
    return nil;
}

- (void)prepareLayoutForLabView:(UTCSLabView *)labView
{
    CGFloat heightMultiplier = CGRectGetHeight(labView.bounds) / [self.meta[@"maximumGridHeight"]floatValue];
    CGFloat widthMultiplier = CGRectGetWidth(labView.bounds) / [self.meta[@"maximumGridWidth"]floatValue];
    
    CGFloat height = CGRectGetHeight(labView.bounds) / 28.25;
    CGFloat width = height;
    
    NSUInteger index = 0;
    NSMutableDictionary *layoutAttributes = [NSMutableDictionary new];
    NSMutableArray      *indexPathLayoutAttributes = [NSMutableArray new];
    for (NSString *key in self.values) {
        NSDictionary *machineCoordinates = self.values[key];
        
        CGFloat x = [machineCoordinates[@"x"]floatValue];
        CGFloat y = [machineCoordinates[@"y"]floatValue];
        
        UTCSLabViewLayoutAttributes *attributes = [UTCSLabViewLayoutAttributes new];
        attributes.indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        attributes.center = CGPointMake(x * widthMultiplier, y * heightMultiplier);
        attributes.size = CGSizeMake(width, height);
        
        layoutAttributes[key] = attributes;
        [indexPathLayoutAttributes addObject:attributes];
        index++;
    }
    self.layoutAttributes = layoutAttributes;
    self.indexPathLayoutAttributes = indexPathLayoutAttributes;
}

- (UTCSLabViewLayoutAttributes *)layoutAttributesForIndexPath:(NSIndexPath *)indexPath
{
    return self.indexPathLayoutAttributes[indexPath.row];
}

- (UTCSLabViewLayoutAttributes *)layoutAttributesForLabMachineName:(NSString *)labMachineName
{
    return self.layoutAttributes[labMachineName];
}


@end

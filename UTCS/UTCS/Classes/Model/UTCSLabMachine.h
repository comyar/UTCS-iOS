//
//  UTCSLabMachine.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(u_int8_t, UTCSLab) {
    UTCSTeachingLab = 0,
    UTCSBasementLab,
    UTCSThirdFloorLab
};

@interface UTCSLabMachine : NSObject

+ (UTCSLabMachine *)labMachineWithParseObject:(PFObject *)object;


/**
 */
- (instancetype)initWithParseObject:(PFObject *)object;

@property (nonatomic) NSString *hostname;
@property (nonatomic) NSInteger labNumber;
@property (nonatomic) NSString *labName;
@property (nonatomic) BOOL      occupied;


@end

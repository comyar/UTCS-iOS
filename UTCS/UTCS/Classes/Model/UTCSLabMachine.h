//
//  UTCSLabMachine.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(u_int8_t, UTCSLabTag) {
    UTCSTeachingLab = 0,
    UTCSBasementLab,
    UTCSThirdFloorLab
};

@interface UTCSLabMachine : NSObject

@property (nonatomic) NSString *lab;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *uptime;

@property (nonatomic) CGFloat   load;
@property (nonatomic) NSInteger users;

@property (nonatomic) BOOL      occupied;



@end

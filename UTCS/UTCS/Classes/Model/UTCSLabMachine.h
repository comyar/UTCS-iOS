//
//  UTCSLabMachine.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/7/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

@import Foundation;


/**
 UTCSLabMachine represents a single machine located in one the 
 UTCS labs.
 */
@interface UTCSLabMachine : NSObject <NSCoding>

// -----
// @name Properties
// -----

/**
 Name of the lab the machine is in
 */
@property (nonatomic) NSString *lab;

/**
 Name of the machine
 */
@property (nonatomic) NSString *name;

/**
 Uptime of the machine
 */
@property (nonatomic) NSString *uptime;

/**
 Status of the machine (up or down)
 */
@property (nonatomic) bool status;

/**
 YES if the machine is physically occupied
 */
@property (nonatomic) bool occupied;

/**
 Current load on the machine
 */
@property (nonatomic) CGFloat load;

@end

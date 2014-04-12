//
//  UTCSFileReader.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/11/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UTCSFileReader : NSObject

/**
 */
+ (id)JSONobjectWithFileNamed:(NSString *)filename extension:(NSString *)extension;

/**
 */
+ (NSString *)valueForKey:(NSString *)key fromJSONobjectWithFileNamed:(NSString *)filename extension:(NSString *)extension;

/**
 */
+ (NSString *)stringContentsOfFileNamed:(NSString *)filename extension:(NSString *)extension;



@end

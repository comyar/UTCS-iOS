//
//  UTCSServiceStackFactory.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;


@class UTCSContentViewController;

extern NSString * const UTCSServiceStackViewControllerClassName;
extern NSString * const UTCSServiceStackDataSourceClassName;
extern NSString * const UTCSServiceStackDataSourceParserClassName;
extern NSString * const UTCSServiceStackDataSourceCacheClassName;



@interface UTCSServiceStackFactory : NSObject

/**
 */
+ (UTCSContentViewController *)controllerForServiceStackConfiguration:(NSDictionary *)configuration;

@end

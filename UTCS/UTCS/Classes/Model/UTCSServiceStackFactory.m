//
//  UTCSServiceStackFactory.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSServiceStackFactory.h"
#import "UTCSDataSource.h"
#import "UTCSDataSourceCache.h"
#import "UTCSDataSourceParser.h"
#import "UTCSAbstractContentViewController.h"

NSString * const UTCSServiceStackViewControllerClassName     = @"UTCSServiceStackViewControllerName";
NSString * const UTCSServiceStackDataSourceClassName         = @"UTCSServiceStackDataSourceName";
NSString * const UTCSServiceStackDataSourceParserClassName   = @"UTCSServiceStackDataSourceParserName";
NSString * const UTCSServiceStackDataSourceCacheClassName    = @"UTCSServiceStackDataSourceCacheName";

#pragma mark - UTCSServiceStackFactory Implementation

@implementation UTCSServiceStackFactory

+ (UTCSAbstractContentViewController *)controllerForServiceStackConfiguration:(NSDictionary *)configuration
{
    UTCSDataSource *dataSource = nil;
    UTCSAbstractContentViewController *viewController = nil;
    UTCSDataSourceParser *parser = nil;
    UTCSDataSourceCache *cache = nil;
    
    for (NSString *key in configuration) {
        id instance = [UTCSServiceStackFactory instanceWithClassName:configuration[key]];
        if (!instance) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"Failed for configuration"
                                         userInfo:configuration];
        }
        
        if ([key isEqualToString:UTCSServiceStackViewControllerClassName]) {
            viewController = (UTCSAbstractContentViewController *)instance;
        } else if ([key isEqualToString:UTCSServiceStackDataSourceClassName]) {
            dataSource = (UTCSDataSource *)instance;
        } else if ([key isEqualToString:UTCSServiceStackDataSourceParserClassName]) {
            parser = (UTCSDataSourceParser *)instance;
        } else if ([key isEqualToString:UTCSServiceStackDataSourceCacheClassName]) {
            cache = (UTCSDataSourceCache *)instance;
        }
    }
    
    dataSource.dataSourceCache = cache;
    dataSource.dataSourceParser = parser;
    viewController.dataSource = dataSource;
    
    return viewController;
}

+ (id)instanceWithClassName:(NSString *)className
{
    if (className) {
        Class class = NSClassFromString(className);
        if (class) {
            id instance = [class new];
            return instance;
        }
    }
    
    return nil;
}



@end

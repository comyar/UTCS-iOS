//
//  UTCSNewsDataSourceParser.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDataSourceParser.h"
#import <AFNetworking/AFNetworking.h>

#pragma mark - UTCSNewsDataSourceParser Interface

/**
 UTCSNewsDataSourceParser is a concrete class used to parse data downloaded by the 
 UTCSNewsDataSource. Instance of UTCSNewsDataSourceParser should only be initialized
 by UTCSNewsDataSource objects.
 
 UTCSNewsDataSourceParser should not be subclassed.
 */
@interface UTCSNewsDataSourceParser : UTCSDataSourceParser

@end

//
//  UTCSDirectoryDataSourceParser.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDataSourceParser.h"


#pragma mark - UTCSDirectoryDataSourceParser Interface

/**
 UTCSDirectoryDataSourceParser is a concrete class used to parse data downloaded by the
 UTCSDirectoryDataSource. Instance of UTCSDirectoryDataSourceParser should only be initialized
 by UTCSDirectoryDataSource objects.
 
 UTCSDirectoryDataSourceParser should not be subclassed.
 */
@interface UTCSDirectoryDataSourceParser : UTCSDataSourceParser

@end

//
//  UTCSEventsDataSourceParser.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDataSourceParser.h"


#pragma mark - UTCSEventsDataSourceParser Interface

/**
 UTCSEventsDataSourceParser is a concrete class used to parse data downloaded by the
 UTCSEventsDataSource. Instance of UTCSEventsDataSourceParser should only be initialized
 by UTCSEventsDataSource objects.
 
 UTCSEventsDataSourceParser should not be subclassed.
 */
@interface UTCSEventsDataSourceParser : UTCSDataSourceParser

@end

//
//  UTCSAbstractDataSourceParser.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;


/**
 UTCSDataSourceParser is an abstract class used to parse downloaded data for a 
 specific service.
 
 For each service, you should create a subclass of UTCSDataSourceParser and override
 the parseValues: selector. Instances of UTCSDataSourceParser should only be used by 
 instances of UTCSDataSource.
 */
@interface UTCSDataSourceParser : NSObject

// -----
// @name Using a UTCSDataSourceParser
// -----

/**
 Parses the given values and returns
 */
- (id)parseValues:(id)values;

// -----
// @name Properties
// -----

/**
 Date formatter used to parse updated date from the downloaded data
 */
@property (nonatomic, readonly) NSDateFormatter *dateFormatter;

@end

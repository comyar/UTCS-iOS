//
//  UTCSAbstractDataSourceParser.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
@import Foundation;


#pragma mark - UTCSDataSourceParser Interface

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
 Parses the given downloaded values into an object or collection of objects
 expected by the data source.
 
 Must be overridden by subclasses. The default implementation is abstract and will
 throw an NSInternalInconsistencyException.
 
 @throws NSInternalInconsistencyException
 @param values  Raw values downloaded by the data source.
 @return Object or collection objects expected by the data source.
 */
- (id)parseValues:(id)values;

// -----
// @name Properties
// -----

/**
 Date formatter used to parse the updated date from the downloaded values.
 */
@property (nonatomic, readonly) NSDateFormatter *dateFormatter;

@end

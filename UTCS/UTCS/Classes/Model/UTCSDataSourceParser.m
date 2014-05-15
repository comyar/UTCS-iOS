//
//  UTCSAbstractDataSourceParser.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports
#import "UTCSDataSourceParser.h"


#pragma mark - UTCSDataSourceParser Class Extension

@interface UTCSDataSourceParser ()

// Date formatter used to parse updated date from the downloaded data
@property (nonatomic) NSDateFormatter *dateFormatter;

@end


#pragma mark - UTCSDataSourceParser Implementation

@implementation UTCSDataSourceParser

- (instancetype)init
{
    if (self = [super init]) {
        self.dateFormatter = ({
            NSDateFormatter *dateFormatter = [NSDateFormatter new];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss"; // Ex: 2014-04-19 14:27:47
            dateFormatter;
        });
    }
    return self;
}

#pragma mark Using a Data Source Parser

- (id)parseValues:(id)values
{
    NSString *reason = [NSString stringWithFormat:@"Cannot perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

@end

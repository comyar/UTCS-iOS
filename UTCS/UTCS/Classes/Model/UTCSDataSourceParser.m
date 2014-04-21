//
//  UTCSAbstractDataSourceParser.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSDataSourceParser.h"


#pragma mark - UtCSDataSourceParser Class Extension

@interface UTCSDataSourceParser ()

//
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

- (id)parseValues:(id)values
{
    return nil;
}

@end

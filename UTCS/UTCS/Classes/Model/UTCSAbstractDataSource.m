//
//  UTCSAbstractDataSource.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/20/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSAbstractDataSource.h"
#import "UTCSAbstractDataSourceParser.h"

#pragma mark - UTCSAbstractDataSource Implementation

@implementation UTCSAbstractDataSource

- (BOOL)shouldUpdate
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Cannot perform abstract selector shouldUpdate"
                                 userInfo:nil];
}

- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion
{
    if (!self.service) {
        if (completion) {
            completion(nil, nil);
        }
        return;
    }
    
    [UTCSDataRequestServicer sendDataRequestWithType:self.requestType argument:argument success:^(NSDictionary *meta, NSDictionary *values) {
        if ([meta[@"service"]isEqualToString:self.service] && meta[@"success"]) {
            
            id data = [self.dataSourceParser parseValues:values];
            
            if (completion) {
                completion(data, nil);
            }
        } else {
            if (completion) {
                completion(nil, [NSError errorWithDomain:UTCSDataRequestServicerErrorDomain code:-1 userInfo:nil]);
            }
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(nil, error);
        }
    }];
}

@end

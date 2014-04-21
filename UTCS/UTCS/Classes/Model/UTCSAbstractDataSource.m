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
    NSString *reason = [NSString stringWithFormat:@"Cannont perform abstract selector %@", NSStringFromSelector(_cmd)];
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:reason
                                 userInfo:nil];
}

- (void)updateWithArgument:(NSString *)argument completion:(UTCSDataSourceCompletion)completion
{
    if (!self.service) {
        if (completion) {
            completion(NO);
        }
        return;
    }
    
    [UTCSDataRequestServicer sendDataRequestWithType:self.requestType argument:argument success:^(NSDictionary *meta, NSDictionary *values) {
        if ([meta[@"service"]isEqualToString:self.service] && meta[@"success"]) {
            
            _data = [self.dataSourceParser parseValues:values];
            
            if (completion) {
                completion(YES);
            }
        } else {
            if (completion) {
                completion(NO);
            }
        }
    } failure:^(NSError *error) {
        if (completion) {
            completion(NO);
        }
    }];
}

@end

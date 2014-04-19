//
//  UTCSDataRequestServicer.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#pragma mark - Imports

// Models
#import "AFNetworking.h"
#import "UTCSDataRequestServicer.h"


#pragma mark - Constants
static NSString *requestURL         = @"http://www.cs.utexas.edu/~czaheri/cgi-bin/utcs.scgi";
static NSString *newsService        = @"news";
static NSString *eventsService      = @"events";
static NSString *labsService        = @"labs";
static NSString *directoryService   = @"directory";
static NSString *diskQuotaService   = @"quota";

#pragma mark - UTCSDataRequestServicer Implementation

@implementation UTCSDataRequestServicer

+ (void)sendDataRequestWithType:(UTCSDataRequestType)dataRequestType
                       argument:(NSString *)argument
                        success:(UTCSDataRequestServicerSuccess)success
                        failure:(UTCSDataRequestServicerFailure)failure
{
    NSURLRequest *request = [UTCSDataRequestServicer requestWithDataRequestType:dataRequestType];
    if (!request) {
        return;
    }
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [operation start];
}



+ (NSURLRequest *)requestWithDataRequestType:(UTCSDataRequestType)dataRequestType
{
    NSURLRequest *request = nil;
    if (dataRequestType == UTCSDataRequestNews) {
        
    } else if (dataRequestType == UTCSDataRequestEvents) {
        
    } else if (dataRequestType == UTCSDataRequestLabs) {
        
    } else if (dataRequestType == UTCSDataRequestDirectory) {
        
    } else if (dataRequestType == UTCSDataRequestDiskQuota) {
        
    }
    return request;
}

@end

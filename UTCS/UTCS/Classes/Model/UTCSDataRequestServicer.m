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
static NSString *requestKey         = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADC";

NSString *UTCSNewsService        = @"news";
NSString *UTCSEventsService      = @"events";
NSString *UTCSLabsService        = @"labs";
NSString *UTCSDirectoryService   = @"directory";
NSString *UTCSDiskQuotaService   = @"quota";

#pragma mark - UTCSDataRequestServicer Implementation

@implementation UTCSDataRequestServicer

+ (void)sendDataRequestWithType:(UTCSDataRequestType)dataRequestType
                       argument:(NSString *)argument
                        success:(UTCSDataRequestServicerSuccess)success
                        failure:(UTCSDataRequestServicerFailure)failure
{
    NSURLRequest *request = [UTCSDataRequestServicer requestWithDataRequestType:dataRequestType
                                                                       argument:argument];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON      = (NSDictionary *)responseObject;
        NSDictionary *meta      = JSON[@"meta"];
        NSDictionary *values    = JSON[@"values"];
        
        if (success) {
            success(meta, values);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
    [operation start];
}



+ (NSURLRequest *)requestWithDataRequestType:(UTCSDataRequestType)dataRequestType argument:(NSString *)argument
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    NSString *service = @"";
    NSString *post = [NSString stringWithFormat:@"key=%@", requestKey];
    
    if (dataRequestType == UTCSDataRequestNews) {
        service = UTCSNewsService;
    } else if (dataRequestType == UTCSDataRequestEvents) {
        service = UTCSEventsService;
    } else if (dataRequestType == UTCSDataRequestLabs) {
        service = UTCSLabsService;
    } else if (dataRequestType == UTCSDataRequestDirectory) {
        service = UTCSDirectoryService;
    } else if (dataRequestType == UTCSDataRequestDiskQuota) {
        service = UTCSDiskQuotaService;
        if (!argument) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                           reason:@"UTCS Disk Quota service requires arguments"
                                         userInfo:nil];
        }
        post = [post stringByAppendingString:[NSString stringWithFormat:@"&arg=%@", argument]];
    }
    
    post = [post stringByAppendingString:[NSString stringWithFormat:@"&service=%@", service]];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setURL:[NSURL URLWithString:requestURL]];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

@end

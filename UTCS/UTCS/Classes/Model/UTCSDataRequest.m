//
//  UTCSDataRequestServicer.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


#pragma mark - Imports

#import "UTCSDataRequest.h"


#pragma mark - Constants

// Request URL
static NSString * const requestURL                  = @"http://www.cs.utexas.edu/~mad/utcs/cgi-bin/utcs.scgi";

// Request API key
static NSString * const requestKey                  = @"gwPtXjpDGgsKWyb8gLrq9OKVVa1dU2uE";

// Name of the meta data in the serialized JSON dictionary
static NSString * const UTCSDataRequestMetaName     = @"meta";

// Name of the values in the serialized JSON dictionary
static NSString * const UTCSDataRequestValuesName   = @"values";


#pragma mark - UTCSDataRequestServicer Implementation

@implementation UTCSDataRequest

#pragma mark Class Methods

+ (void)sendDataRequestForService:(NSString *)service
                         argument:(NSString *)argument
                          completion:(UTCSDataRequestCompletion)completion
{
    if (!completion) {
        return;
    }
    
    NSURLRequest *request = [UTCSDataRequest requestWithService:service argument:argument];
    
    // Create request operation, serialize JSON
    AFHTTPRequestOperation *operation   = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer        = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON      = (NSDictionary *)responseObject;
        NSDictionary *meta      = JSON[UTCSDataRequestMetaName];
        id values               = JSON[UTCSDataRequestValuesName];
        completion(meta, values, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, nil, error);
    }];
    
    [operation start];
}

+ (NSURLRequest *)requestWithService:(NSString *)service argument:(NSString *)argument
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    // Construct POST arguments
    NSString *post = [NSString stringWithFormat:@"key=%@", requestKey];
    if (argument) {
        post = [post stringByAppendingString:[NSString stringWithFormat:@"&arg=%@", argument]];
    }
    post = [post stringByAppendingString:[NSString stringWithFormat:@"&service=%@", service]];
    
    // Configure request
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding];
    [request setURL:[NSURL URLWithString:requestURL]];
    [request setHTTPBody:postData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    return request;
}

@end

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
static NSString *requestKey         = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADp";

NSString *UTCSDataRequestServicerErrorDomain = @"UTCSDataRequestServicerError";

#pragma mark - UTCSDataRequestServicer Implementation

@implementation UTCSDataRequestServicer

+ (void)sendDataRequestForService:(NSString *)service
                         argument:(NSString *)argument
                          completion:(UTCSDataRequestServicerCompletion)completion
{
    if (!completion) {
        return;
    }
    
    
    NSURLRequest *request = [UTCSDataRequestServicer requestWithService:service argument:argument];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *JSON      = (NSDictionary *)responseObject;
        NSDictionary *meta      = JSON[@"meta"];
        id values               = JSON[@"values"];
        
        completion(meta, values, nil);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        completion(nil, nil, error);

    }];
    
    [operation start];
}

+ (NSURLRequest *)requestWithService:(NSString *)service argument:(NSString *)argument
{
    NSMutableURLRequest *request = [NSMutableURLRequest new];
    
    NSString *post = [NSString stringWithFormat:@"key=%@", requestKey];

    post = [post stringByAppendingString:[NSString stringWithFormat:@"&arg=%@", argument]];
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

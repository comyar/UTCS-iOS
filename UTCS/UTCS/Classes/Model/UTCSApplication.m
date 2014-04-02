//
//  UTCSApplication.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSApplication.h"

@implementation UTCSApplication

- (BOOL)openURL:(NSURL *)url
{
    // Get URL scheme and check if it is http or https
    NSString *scheme = [[url scheme]lowercaseString];
    
    // If the URL is a web address and a URL handler has been set, execute the URL handler block
    if(([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) && self.urlHandler) {
        return self.urlHandler(url);
    }
    return [super openURL:url];
}

@end

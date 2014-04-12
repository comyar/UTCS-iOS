//
//  UTCSFileReader.m
//  UTCS
//
//  Created by Comyar Zaheri on 4/11/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UTCSFileReader.h"

@implementation UTCSFileReader

+ (NSString *)stringContentsOfFileNamed:(NSString *)filename extension:(NSString *)extension
{
    NSString *path = [[NSBundle mainBundle]pathForResource:filename
                                                    ofType:extension];
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];
    return content;
}


+ (id)JSONobjectWithFileNamed:(NSString *)filename extension:(NSString *)extension
{
    NSString *jsonString = [UTCSFileReader stringContentsOfFileNamed:filename
                                                           extension:extension];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:NSJSONReadingAllowFragments
                                             error:nil];
}

+ (NSString *)valueForKey:(NSString *)key fromJSONobjectWithFileNamed:(NSString *)filename extension:(NSString *)extension
{
    NSDictionary *json = [UTCSFileReader JSONobjectWithFileNamed:filename extension:extension];
    return json[key];
}

@end

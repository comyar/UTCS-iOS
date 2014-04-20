//
//  UTCSDataRequestServicer.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/19/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

/**
 */
typedef NS_ENUM(NSInteger, UTCSDataRequestType) {
    UTCSDataRequestNews = 0,
    UTCSDataRequestEvents,
    UTCSDataRequestLabs,
    UTCSDataRequestDirectory,
    UTCSDataRequestDiskQuota
};


extern NSString *UTCSNewsService;
extern NSString *UTCSEventsService;
extern NSString *UTCSLabsService;
extern NSString *UTCSDirectoryService;
extern NSString *UTCSDiskQuotaService;
extern NSString *UTCSDataRequestServicerErrorDomain;

/**
 */
typedef void (^UTCSDataRequestServicerSuccess)(NSDictionary *meta, NSDictionary *values);

/**
 */
typedef void (^UTCSDataRequestServicerFailure)(NSError *error);


/**
 */
@interface UTCSDataRequestServicer : NSObject

+ (void)sendDataRequestWithType:(UTCSDataRequestType)dataRequestType
                       argument:(NSString *)argument
                        success:(UTCSDataRequestServicerSuccess)success
                        failure:(UTCSDataRequestServicerFailure)failure;

@end

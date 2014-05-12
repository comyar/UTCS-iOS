//
//  UTCSStarredEventManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

@interface UTCSStarredEventManager : NSObject

+ (UTCSStarredEventManager *)sharedManager;

- (NSArray *)allEventIDs;
- (BOOL)containsEventID:(NSString *)eventID;
- (void)addEventID:(NSString *)eventID;
- (void)removeEventID:(NSString *)eventID;
- (void)removeAllEventIDs;

@end

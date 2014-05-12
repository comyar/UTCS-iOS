//
//  UTCSStarredEventManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 5/12/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;
@class UTCSEvent;


@interface UTCSStarredEventManager : NSObject

+ (UTCSStarredEventManager *)sharedManager;

- (NSArray *)allEvents;
- (BOOL)containsEvent:(UTCSEvent *)event;
- (void)addEvent:(UTCSEvent *)event;
- (void)removeEvent:(UTCSEvent *)event;
- (void)removeAllEvents;
- (void)purgePastEvents;

@end

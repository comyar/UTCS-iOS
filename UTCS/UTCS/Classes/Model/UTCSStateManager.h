//
//  UTCSSettingsManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 4/21/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//


@import Foundation;

@interface UTCSStateManager : NSObject

+ (UTCSStateManager *)sharedManager;

@property (nonatomic) BOOL      hasStarredEvent;
@property (nonatomic) NSArray   *starredEvents;
@property (nonatomic) NSArray   *starredEventNotifications;
@property (nonatomic) BOOL      eventNotifications;
@property (nonatomic) NSInteger preferredLab;

@end

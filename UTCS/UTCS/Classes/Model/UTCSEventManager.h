//
//  UTCSEventManager.h
//  UTCS
//
//  Created by Comyar Zaheri on 3/16/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ UTCSEventManagerCompletion) (NSArray *events, NSError *error);


extern NSString * const UTCSEventTitleFontAttribute;
extern NSString * const UTCSEventTitleTextColorAttribute;

extern NSString * const UTCSEventDateFontAttribute;
extern NSString * const UTCSEventDateTextColorAttribute;

extern NSString * const UTCSEventTextFontAttribute;
extern NSString * const UTCSEventTextTextColorAttribute;

extern NSString * const UTCSEventContactFontAttribute;
extern NSString * const UTCSEventContactTextColorAttribute;

extern NSString * const UTCSEventDescriptionLineSpacing;

/**
 */
@interface UTCSEventManager : NSObject

/**
 */
+ (void)eventsWithFontAttributes:(NSDictionary *)attributes completion:(UTCSEventManagerCompletion)completion;

@end

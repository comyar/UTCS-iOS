//
//  UTCSGlobal.h
//  UTCS
//
//  Created by Comyar Zaheri on 2/8/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#ifndef UTCS_UTCSGlobal_h
#define UTCS_UTCSGlobal_h

// ------------
// @name Colors
// -------------

#define RGB(val) ((1.0 * val) / 255.0)

// ------------
// @name Parse
// -------------

#define PARSE_EVENT_CLASS           @"Event"
#define PARSE_NEWSSTORY_CLASS       @"NewsStory"

// ------------
// @name Types
// -------------

typedef NS_ENUM(NSInteger, UTCSMenuOptions) {
    UTCSMenuOptionNews = 0,
    UTCSMenuOptionEvents,
    UTCSMenuOptionLabs,
    UTCSMenuOptionDirectory
};

#endif

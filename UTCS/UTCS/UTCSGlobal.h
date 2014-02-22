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
#define COLOR_BURNT_ORANGE  [UIColor colorWithRed:RGB(203) green:RGB(96) blue:RGB(21) alpha:1.0]
#define COLOR_YELLOW        [UIColor colorWithRed:RGB(242) green:RGB(169) blue:RGB(0) alpha:1.0]
#define COLOR_GRAY          [UIColor colorWithRed:RGB(153) green:RGB(153) blue:RGB(153) alpha:1.0]
#define COLOR_DARK_GRAY     [UIColor colorWithRed:RGB(51) green:RGB(51) blue:RGB(51) alpha:1.0]

// ------------
// @name Parse
// -------------

#define PARSE_EVENT_CLASS           @"Event"
#define PARSE_EVENT_NAME            @"name"
#define PARSE_EVENT_DESCRIPTION     @"cleanedDescription"
#define PARSE_EVENT_LOCATION        @"location"
#define PARSE_EVENT_DATE_START      @"dateStart"
#define PARSE_EVENT_DATE_END        @"dateEnd"


// ------------
// @name Types
// -------------

typedef NS_ENUM(NSInteger, UTCSMenuOptions) {
    UTCSMenuOptionNews = 0,
    UTCSMenuOptionEvents,
    UTCSMenuOptionLabs
};

#endif

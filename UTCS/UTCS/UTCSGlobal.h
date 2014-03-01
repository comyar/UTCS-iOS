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
#define PARSE_EVENT_NAME            @"name"
#define PARSE_EVENT_DESCRIPTION     @"description"
#define PARSE_EVENT_LOCATION        @"location"
#define PARSE_EVENT_CONTACT_EMAIL   @"contactEmail"
#define PARSE_EVENT_CONTACT_NAME    @"contactName"
#define PARSE_EVENT_DATE_START      @"dateStart"
#define PARSE_EVENT_DATE_END        @"dateEnd"


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

//
//  UIColor+UTCSColors.m
//  UTCS
//
//  Created by Comyar Zaheri on 3/1/14.
//  Copyright (c) 2014 UTCS. All rights reserved.
//

#import "UIColor+UTCSColors.h"

#define RGB(val) ((1.0 * val) / 255.0)

@implementation UIColor (UTCSColors)

+ (UIColor *)utcsBurntOrangeColor
{
    return [UIColor colorWithRed:RGB(203) green:RGB(96) blue:RGB(21) alpha:1.0];
}

+ (UIColor *)utcsYellowColor
{
    return [UIColor colorWithRed:RGB(242) green:RGB(169) blue:RGB(0) alpha:1.0];
}

+ (UIColor *)utcsDarkGrayColor
{
    return [UIColor colorWithRed:RGB(51) green:RGB(51) blue:RGB(51) alpha:1.0];
}

+ (UIColor *)utcsRedColor
{
    return [UIColor colorWithRed:RGB(204) green:RGB(0) blue:RGB(17) alpha:1.0];
}

+ (UIColor *)utcsGrayColor
{
    return [UIColor colorWithRed:RGB(102) green:RGB(102) blue:RGB(102) alpha:1.0];
}

+ (UIColor *)utcsLightGrayColor
{
    return [UIColor colorWithRed:RGB(153) green:RGB(153) blue:RGB(153) alpha:1.0];
}

+ (UIColor *)utcsTableViewSeparatorColor
{
    return [UIColor colorWithRed:RGB(225) green:RGB(225) blue:RGB(225) alpha:1.0];
}

+ (UIColor *)utcsTableViewHeaderColor
{
    return [UIColor colorWithRed:RGB(210) green:RGB(210) blue:RGB(210) alpha:1.0];
}

+ (UIColor *)utcsRefreshControlColor
{
    return [UIColor colorWithRed:RGB(200) green:RGB(200) blue:RGB(200) alpha:1.0];
}

+ (UIColor *)utcsBarTintColor
{
    return [UIColor colorWithWhite:0.95 alpha:1.0];
}

+ (UIColor *)utcsImageTintColor
{
    return [UIColor colorWithWhite:0.11 alpha:0.5];
}

+ (UIColor *)utcsCalendarColor
{
    return [UIColor colorWithRed:RGB(220) green:RGB(57) blue:RGB(38) alpha:1.0];
}


@end

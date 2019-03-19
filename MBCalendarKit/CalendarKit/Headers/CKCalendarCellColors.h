//
//  CKCalendarCellColors.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

/*
 
 Defines standard colors for CKCalendarView. These were grabbed using the
 color picker in Photoshop CS6 on OS X. There's a gradient across the calendar,
 from the top down, so the colors change slightly by row.
 
 Selected Blue: #1980e5
 Normal Gray (Top Row): #e2e2e4
 Normal Gray (Bottom Row): #cccbd0
 
 Text Gradient Top Color: #2b3540
 Text Gradient Bottom Color: #495a6d
 
 As part of a performance audit on 9/5/17, the hex category was replaced with 
 standard UIColors, converted using http://uicolor.xyz.
 
 */


#ifndef MBCalendarKit_CKCalendarCalendarCellColors_h
#define MBCalendarKit_CKCalendarCalendarCellColors_h

#define kCalendarColorBlue [UIColor colorWithRed:0.10 green:0.50 blue:0.90 alpha:1.0];
#define kCalendarColorLightGray [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.0]
#define kCalendarColorDarkGray [UIColor colorWithRed:0.80 green:0.80 blue:0.82 alpha:1.0]

#define kCalendarColorBluishGray [UIColor colorWithRed:0.45 green:0.54 blue:0.65 alpha:1.0]
#define kCalendarColorTodayShadowBlue [UIColor colorWithRed:0.22 green:0.27 blue:0.32 alpha:1.0]
#define kCalendarColorSelectedShadowBlue [UIColor colorWithRed:0.16 green:0.31 blue:0.46 alpha:1.0]

#define kCalendarColorDarkTextGradient [UIColor colorWithRed:0.17 green:0.21 blue:0.25 alpha:1.0]
#define kCalendarColorLightTextGradient [UIColor colorWithRed:0.29 green:0.35 blue:0.43 alpha:1.0]

#define kCalendarColorCellBorder [UIColor colorWithRed:0.62 green:0.63 blue:0.66 alpha:1.0]
#define kCalendarColorSelectedCellBorder [UIColor colorWithRed:0.16 green:0.21 blue:0.29 alpha:1.0]

#endif

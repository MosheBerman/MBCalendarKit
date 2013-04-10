//
//  CKCakeCalendarCellColors.h
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

/*
 
 Defines standard colors for MBCakeCalendarView. These were grabbed using the
 color picker in Photoshop CS6 on OS X. There's a gradient across the calendar,
 from the top down, so the colors change slightly by row.
 
 Selected Blue: #1980e5
 Normal Gray (Top Row): #e2e2e4
 Normal Gray (Bottom Row): #cccbd0
 
 Text Gradient Top Color: #2b3540
 Text Gradient Bottom Color: #495a6d
 
 */


#ifndef MBChocolateCake_CKCakeCalendarCellColors_h
#define MBChocolateCake_CKCakeCalendarCellColors_h

#import "NSString+Color.h"

#define kCakeColorBlue [@"#1980e5" toColor]
#define kCakeColorLightGray [@"#e2e2e4" toColor]
#define kCakeColorDarkGray [@"#cccbd0" toColor]

#define kCakeColorDarkTextGradient [@"#2b3540" toColor]
#define kCakeColorLightTextGradient [@"#495a6d" toColor]

#endif

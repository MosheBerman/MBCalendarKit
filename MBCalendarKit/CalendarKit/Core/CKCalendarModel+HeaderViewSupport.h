//
//  CKCalendarModel+HeaderViewSupport.h
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/10/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

#import "CKCalendarModel.h"
#import "CKCalendarHeaderViewDelegate.h"
#import "CKCalendarHeaderViewDataSource.h"

@interface CKCalendarModel (HeaderViewSupport) <CKCalendarHeaderViewDataSource, CKCalendarHeaderViewDelegate>

@end

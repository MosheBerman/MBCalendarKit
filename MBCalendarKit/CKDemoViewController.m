//
//  CKDemoViewController.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/17/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKDemoViewController.h"

#import "NSCalendarCategories.h"

#import "NSDate+Components.h"

@interface CKDemoViewController () <CKCalendarViewDelegate, CKCalendarViewDataSource>
    @property (nonatomic, strong) NSMutableDictionary *data;
@end

@implementation CKDemoViewController

- (id)init
{
    self = [super init];
    if (self) {
        [self setDataSource:self];
        [self setDelegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    /*
    NSDate *min = [NSDate dateWithDay:10 month:4 year:2013];
    NSDate *max = [NSDate dateWithDay:20 month:4 year:2013];
    
    [[self calendarView] setMaximumDate:max];
    [[self calendarView] setMinimumDate:min];
     */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    return [self data][date];
}

#pragma mark - CKCalendarViewDelegate

// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date
{
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{
    
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    
}
@end

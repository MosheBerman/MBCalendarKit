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
#import "EventDetailViewController.h"
@interface CKDemoViewController () <CKCalendarViewDelegate, CKCalendarViewDataSource>{
    NSMutableArray *events;
    NSMutableDictionary *_eventsDict;
}


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
    events = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *_infoDict = [[NSMutableDictionary alloc] init];
    _eventsDict = [[NSMutableDictionary alloc] init];
    
    
    CKCalendarEvent* aCKCalendarEvent = [[CKCalendarEvent alloc] init];
    [_infoDict setObject:@"Lahore,Punjab, Pakistan" forKey:@"Location"];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd/mm/yyyy"];
    NSDate *date = [dateformatter dateFromString: @"11/04/2014"];
    aCKCalendarEvent.date = date;
    aCKCalendarEvent.title = @"Wedding";
    aCKCalendarEvent.info = _infoDict;
    [events addObject: aCKCalendarEvent];
    [_eventsDict setObject: events forKey: [[NSDate dateWithDay:11 month:04 year:2014] description]];

    ////add another event
    aCKCalendarEvent = [[CKCalendarEvent alloc] init];
    [dateformatter setDateFormat:@"dd/mm/yyyy"];
    date = [dateformatter dateFromString: @"11/04/2014"];
    aCKCalendarEvent.date = date;
    aCKCalendarEvent.title = @"Project Planning";
    aCKCalendarEvent.info = _infoDict;
    [events addObject: aCKCalendarEvent];
    [_eventsDict setObject: events forKey: [[NSDate dateWithDay:11 month:04 year:2014] description]];
    
    // adding another event
    NSMutableArray *secondDayEvents = [[NSMutableArray alloc] init];
    aCKCalendarEvent = [[CKCalendarEvent alloc] init];
    [dateformatter setDateFormat:@"dd/mm/yyyy"];
    date = [dateformatter dateFromString: @"11/04/2014"];
    aCKCalendarEvent.date = date;
    aCKCalendarEvent.info = _infoDict;
    aCKCalendarEvent.title = @"Birthday Party";
    [secondDayEvents addObject: aCKCalendarEvent];
    [_eventsDict setObject:secondDayEvents forKey: [[NSDate dateWithDay:12 month:04 year:2014] description]];

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
    NSArray *dateComponents =  [date dateComponentsFromDate:date];
    NSInteger day = [[dateComponents objectAtIndex:0] integerValue];
    NSInteger month = [[dateComponents objectAtIndex:1] integerValue];
    NSInteger year = [[dateComponents objectAtIndex:2] integerValue];
    NSDate *convertedDate = [NSDate dateWithDay:day month:month year:year];
    
    if ([[_eventsDict allKeys] containsObject:[convertedDate description] ]) {
        return [_eventsDict valueForKey:[convertedDate description]];
    }
    
    return nil;
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
    EventDetailViewController *eventDetail = [[EventDetailViewController alloc] initWithNibName:@"EventDetailViewController" bundle:nil];
    
    eventDetail.selectedEvent = event;
    [self presentViewController:eventDetail animated:YES completion:NULL];
}
@end

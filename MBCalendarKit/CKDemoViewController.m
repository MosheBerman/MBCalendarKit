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

- (void)viewDidLoad
{
    [super viewDidLoad];

    /**
     *  Create a dictionary for the data source
     */
    
    self.data = [[NSMutableDictionary alloc] init];
    
    /**
     *  Wire up the data source and delegate.
     */
    
    [self setDataSource:self];
    [self setDelegate:self];
    
    /**
     *  Create some events.
     */
    
    //  An event for the new MBCalendarKit release.
    NSString *title = NSLocalizedString(@"Release MBCalendarKit 2.2.4", @"A localized string describing the release date.");
    NSDate *date = [NSDate dateWithDay:28 month:11 year:2014];
    CKCalendarEvent *releaseUpdatedCalendarKit = [CKCalendarEvent eventWithTitle:title andDate:date andInfo:nil];
    
    //  An event for when I want to order a new iPhone.
    NSString *title2 = NSLocalizedString(@"The Hunger Games: Mockingjay, Part 1", @"A localized string describing when the new Hunger Games comes out.");
    NSDate *date2 = [NSDate dateWithDay:21 month:11 year:2014];
    CKCalendarEvent *mockingJay = [CKCalendarEvent eventWithTitle:title2 andDate:date2 andInfo:nil];
    
    //  An event for the 100 year anniversary of the British capture Basra
    NSString *title3 = NSLocalizedString(@"The British Capture Basra (100 year anniversary)", @"A localized string describing the event title.");
    CKCalendarEvent *britishBasra = [CKCalendarEvent eventWithTitle:title3 andDate:date2 andInfo:nil];
    
    
    //  An event for when I want to order a new iPhone.
    NSString *title4 = NSLocalizedString(@"Order iPhone 6 Plus", @"A localized string describing when I order a new iPhone.");
    NSDate *date4 = [NSDate dateWithDay:28 month:2 year:2015];
    CKCalendarEvent *orderNewPhone = [CKCalendarEvent eventWithTitle:title4 andDate:date4 andInfo:nil];
    
    /**
     *  Add the events to the data source.
     *
     *  The key is the date that the array of events appears on.
     */
    
    self.data[date] = @[releaseUpdatedCalendarKit];
    self.data[date2] = @[britishBasra, mockingJay];
    self.data[date4] = @[orderNewPhone];
}

- (void)viewDidAppear:(BOOL)animated
{
    /**
     * Here's an example of setting min/max dates.
     */
    
    /*
     NSDate *min = [NSDate dateWithDay:1 month:4 year:2014];
     NSDate *max = [NSDate dateWithDay:31 month:12 year:2015];
     
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

//
//  CKViewController.m
//  MBChocolateCake
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKViewController.h"

#import "CKCakeView.h"

#import "CKCakeEvent.h"

#import "NSCalendarCategories.h"

@interface CKViewController () <CKCakeViewDataSource, CKCakeViewDelegate>

@property (nonatomic, strong) CKCakeView *calendarView;
@property (nonatomic, strong) UISegmentedControl *modePicker;

@property (nonatomic, strong) NSMutableArray *events;

@end

@implementation CKViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /* Orange bg for sanity */
    
    [[self view] setBackgroundColor:[UIColor orangeColor]];
    
    /* Calendar View */
    

    [self setCalendarView:[CKCakeView new]];
    [[self calendarView] setDataSource:self];
    [[self calendarView] setDelegate:self];
    [[self view] addSubview:[self calendarView]];

    [[self calendarView] setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [[self calendarView] setDisplayMode:CKCakeViewModeMonth];
    
    /* Mode Picker */
    
    NSArray *items = @[@"Month", @"Week", @"Day"];
    [self setModePicker:[[UISegmentedControl alloc] initWithItems:items]];
    
    //  Set the style
    [[self modePicker] setSegmentedControlStyle:UISegmentedControlStyleBar]  ;
    
    //  Register for segment selection events
    [[self modePicker] addTarget:self action:@selector(modeChangedUsingControl:) forControlEvents:UIControlEventValueChanged];
    
    [[self modePicker] setSelectedSegmentIndex:0];
    
    /* Toolbar setup */
    
    NSString *todayTitle = NSLocalizedString(@"Today", @"A button which sets the calendar to today.");
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:todayTitle style:UIBarButtonItemStyleBordered target:self action:@selector(todayButtonTapped:)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:[self modePicker]];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [self setToolbarItems:@[
     todayButton, space, item, space, space] animated:NO];
    [[self navigationController] setToolbarHidden:NO animated:NO];
    
    /* Prepare the events array */
    
    [self setEvents:[NSMutableArray new]];
    
    /* Make a dummy event */
    
    NSDate *date = [NSDate date];
    CKCakeEvent *event = [[CKCakeEvent alloc] init];
    [event setTitle:@"First event"];
    [event setDate:date];
    [[self events] addObject:event];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Toolbar Items

- (void)modeChangedUsingControl:(id)sender
{
    [[self calendarView] setDisplayMode:[[self modePicker] selectedSegmentIndex]];
}

- (void)todayButtonTapped:(id)sender
{
    [[self calendarView] setDate:[NSDate date]];
}



#pragma mark - CKCakeViewDataSource

- (NSArray *)cakeView:(CKCakeView *)cakeView eventsForDate:(NSDate *)date
{
    NSMutableArray *eventsForDate = [NSMutableArray new];
    
    NSCalendar *calendar = [cakeView calendar];

    for (CKCakeEvent *event in [self events]) {

        NSDate *eventDate = [event date];
        
        if ([calendar date:date isSameDayAs:eventDate]) {
            [eventsForDate addObject:event];
        }
    }
    
    return eventsForDate;
}

#pragma mark - CKCakeViewDelegate

// Called before/after the selected date changes
- (void)cakeView:(CKCakeView *)cakeView willSelectDate:(NSDate *)date
{
    
}

- (void)cakeView:(CKCakeView *)cakeView didSelectDate:(NSDate *)date
{
    
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)cakeView:(CKCakeView *)cakeView didSelectEvent:(CKCakeEvent *)event
{
     
}

@end

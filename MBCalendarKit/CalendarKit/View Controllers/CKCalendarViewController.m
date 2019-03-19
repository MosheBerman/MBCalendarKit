//
//  CKViewController.m
//  MBCalendarKit
//
//  Created by Moshe Berman on 4/10/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import "CKCalendarView.h"
#import "CKCalendarEvent.h"
#import "NSCalendarCategories.h"

#import "CKTableViewCell.h"

#import "CKCalendarViewController.h"

@interface CKCalendarViewController () <CKCalendarViewDataSource, CKCalendarViewDelegate, UITableViewDataSource, UITableViewDelegate>

/**
 The calendar view used in the view controller.
 */
@property (nonatomic, strong, nonnull) CKCalendarView *calendarView;

/**
 A control that allows users to choose between month, week, and day modes.
 */
@property (nonatomic, strong, nonnull) UISegmentedControl *modePicker;


/**
 The events to display in the calendar.
 */
@property (nonatomic, strong, nonnull) NSArray <CKCalendarEvent *> *events;

@end

@implementation CKCalendarViewController

// MARK: Initializers

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self _commonInitializer];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self)
    {
        [self _commonInitializer];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _commonInitializer];
    }
    return self;
}

// MARK: - Common Initialization

- (void)_commonInitializer
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"noDataCell"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    NSArray *items = @[
                       NSLocalizedString(@"Month", @"A title for the month view button."),
                       NSLocalizedString(@"Week",@"A title for the week view button."),
                       NSLocalizedString(@"Day", @"A title for the day view button.")];
    
    _modePicker = [[UISegmentedControl alloc] initWithItems:items];
    [self.modePicker addTarget:self action:@selector(modeChangedUsingControl:) forControlEvents:UIControlEventValueChanged];
    self.modePicker.selectedSegmentIndex = 0;
}

// MARK: - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if(!self.title)
    {
        [self setTitle:NSLocalizedString(@"Calendar", @"A title for the calendar view.")];
    }
    
    /* Prepare the events array */
    
    self.events = [NSMutableArray new];
    
    [self installCalendarView];
    [self installTableView];
    [self installToolbar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: - Configure Calendar View

- (void)installCalendarView
{
    self.calendarView = [[CKCalendarView alloc] init];
    self.calendarView.dataSource = self;
    self.calendarView.delegate = self;
    [self installShadow];
    [self.view addSubview:self.calendarView];
    [self layoutCalendar];
}

/**
 This method sets up constraints on the calendar view.
 */

- (void)layoutCalendar
{
    self.calendarView.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.calendarView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.topLayoutGuide
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:0.0];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.calendarView
                                                               attribute:NSLayoutAttributeCenterX
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.view
                                                               attribute:NSLayoutAttributeCenterX
                                                              multiplier:1.0
                                                                constant:0.0];
    
    [self.view addConstraints:@[top, centerX]];
    
}


// MARK: - Install Table View

- (void)installTableView
{
    if (![self.view.subviews containsObject:self.tableView])
    {
        /* Set up the table */
        [self.view addSubview:self.tableView];
        [self.view bringSubviewToFront:self.calendarView];
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                   attribute:NSLayoutAttributeLeading
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.view
                                                                   attribute:NSLayoutAttributeLeading
                                                                  multiplier:1.0
                                                                    constant:0.0];
        
        NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                    attribute:NSLayoutAttributeTrailing
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.view
                                                                    attribute:NSLayoutAttributeTrailing
                                                                   multiplier:1.0
                                                                     constant:0.0];
        
        NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.tableView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.calendarView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1.0
                                                                constant:0.0];
        
        NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.tableView
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0
                                                                   constant:0.0];
        
        [self.view addConstraints:@[leading, trailing, top, bottom]];
    }
}



// MARK: - Allows Users to Install The Shadows

/**
 Install the shadow on the calendar.
 */
- (void)installShadow
{
    (self.calendarView.layer).shadowOpacity = 1.0;
    (self.calendarView.layer).shadowColor = UIColor.darkGrayColor.CGColor;
    (self.calendarView.layer).shadowOffset = CGSizeMake(0, 3);
}


// MARK: - Installing Toolbar

- (void)installToolbar
{
    NSString *todayTitle = NSLocalizedString(@"Today", @"A button which sets the calendar to today.");
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:todayTitle style:UIBarButtonItemStylePlain target:self action:@selector(todayButtonTapped:)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.modePicker];
    
    [self setToolbarItems:@[todayButton, item] animated:NO];
    [self.navigationController setToolbarHidden:NO animated:NO];
}

// MARK: - Toolbar Items

- (void)modeChangedUsingControl:(id)sender
{
    self.calendarView.displayMode = (CKCalendarViewDisplayMode)self.modePicker.selectedSegmentIndex;
}

- (void)todayButtonTapped:(id)sender
{
    [self.calendarView setDate:[NSDate date] animated:NO];
}

// MARK: - CKCalendarViewDataSource

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    if ([self.dataSource respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        return [self.dataSource calendarView:calendarView eventsForDate:date];
    }
    return nil;
}

// MARK: - Setting the Data Source

/**
 Sets the data source. Setting this also causes the cache to reload, and the table view to reload as well.

 @param dataSource The data source for the calendar view controller.
 */
- (void)setDataSource:(id<CKCalendarViewDataSource>)dataSource
{
    _dataSource = dataSource;
    self.calendarView.dataSource = dataSource;

    [self updateCacheWithSortedEvents];
    [self.tableView reloadData];
}

/**
 Asks the data source for events for a given date. 
 Then, sorts the events by date and caches them locally.
 */
- (void)updateCacheWithSortedEvents
{
    /**
     *  Sort & cache the events for the current date.
     */
    
    if ([self.dataSource respondsToSelector:@selector(calendarView:eventsForDate:)]) {
        NSArray *sortedArray = [[self.dataSource calendarView:self.calendarView eventsForDate:self.calendarView.date] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDate *d1 = [obj1 date];
            NSDate *d2 = [obj2 date];
            
            return [d1 compare:d2];
        }];
        
        self.events = sortedArray;
    }
}

// MARK: - CKCalendarViewDelegate

// Called before the selected date changes
- (void)calendarView:(CKCalendarView *)calendarView willSelectDate:(NSDate *)date
{
    if ([self isEqual:self.delegate])
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:willSelectDate:)]) {
        [self.delegate calendarView:calendarView willSelectDate:date];
    }
}

// Called after the selected date changes
- (void)calendarView:(CKCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    [self updateCacheWithSortedEvents];
    [self.tableView reloadData];

    if ([self isEqual:self.delegate])
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        [self.delegate calendarView:calendarView didSelectDate:date];
    }
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)calendarView didSelectEvent:(CKCalendarEvent *)event
{
    if ([self isEqual:self.delegate])
    {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectEvent:)]) {
        [self.delegate calendarView:calendarView didSelectEvent:event];
    }
}

#pragma mark - Calendar View

- (CKCalendarView *)calendarView
{
    return _calendarView;
}

#pragma mark - Orientation Support

- (void)willTransitionToTraitCollection:(UITraitCollection *)newCollection withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self.calendarView reloadAnimated:NO];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        
    }];
}

// MARK: - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = self.events.count;
    
    if (count == 0) {
        count = 2;
    }
    
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger count = self.events.count;
    
    if (count == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noDataCell"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:0.8];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (indexPath.row == 1) {
            [cell.textLabel setText:NSLocalizedString(@"No Events", @"A label for a table with no events.")];
        }
        else
        {
            cell.textLabel.text = @"";
        }
        return cell;
    }
    
    CKTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    CKCalendarEvent *event = self.events[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = event.title;
    
    UIView *colorView = [[UIView alloc] initWithFrame:CGRectMake(3, 6, 20, 20)];
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = event.color.CGColor;
    layer.frame = colorView.frame;
    [colorView.layer insertSublayer:layer atIndex:0];
    
    if(nil != event.image)
    {
        cell.imageView.image = [UIImage imageWithData:event.image];
    }
    else {
        cell.imageView.image = nil;
    }
    
    [cell addSubview:colorView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.events.count == 0) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didSelectEvent:)]) {
        [self.delegate calendarView:self.calendarView didSelectEvent:self.events[indexPath.row]];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end

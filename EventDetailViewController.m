//
//  EventDetailViewController.m
//  MBCalendarKit
//
//  Created by Asif Noor on 4/11/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "EventDetailViewController.h"

@interface EventDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end

@implementation EventDetailViewController
@synthesize selectedEvent;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.eventDateLabel.text = [selectedEvent.date description];
    self.eventTitleLabel.text = selectedEvent.title;
    self.locationLabel.text = [selectedEvent.info valueForKey:@"Location"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)navigateToCalendar:(id)sender {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end

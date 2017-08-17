//
//  SwiftDemoViewController.swift
//  MBCalendarKit
//
//  Created by Moshe on 1/9/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

import UIKit
import MBCalendarKit

class SwiftDemoViewController: CalendarViewController
{
    var data : [Date:[CalendarEvent]] = [:]
    
    required init?(coder aDecoder: NSCoder) {
        
        self.data = [:]
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        self.data = [:]
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //
        //  Step 0 : Wire up the data source and delegate
        //
        
        self.delegate = self
        self.dataSource = self
        
        
        //  Define some events
        
        
        let title : NSString = NSLocalizedString("Add Swift Demo", comment: "") as NSString
        if let date : Date = NSDate(day: 9, month: 1, year: 2015) as Date?
        {
            let event : CalendarEvent = CalendarEvent(title: title as String, andDate: date, andInfo: nil)
            self.data[date] = [event]
        }
        
        let title2 : NSString = NSLocalizedString("Release MBCalendarKit 5.0.0", comment: "") as NSString
        if let date2 : Date = NSDate(day: 15, month: 8, year: 2017) as Date?
        {
            let event2 : CalendarEvent = CalendarEvent(title: title2 as String, andDate: date2, andInfo: nil)
            self.data[date2] = [event2]
        }
        
        
        
    }
    
    //  MARK: - CalendarDataSource
    
    /**
     Allows the data source to supply events to display on the calendar.
     
     @param calendarView The calendar view instance that will display the data.
     @param date The date for which the calendar view wants events.
     @return An array of events objects.
     */
    override func calendarView(_ calendarView: CalendarView, eventsFor date: Date) -> [CalendarEvent] {
        
        let eventsForDate = self.data[date] ?? []
        
        return eventsForDate
    }
    
    
    // MARK: - CKCalendarDelegate
    
    // Called before the selected date changes.
    override func calendarView(_ calendarView: CalendarView, didSelect date: Date) {
        super.calendarView(calendarView, didSelect: date) // Call super to ensure it
    }
    
    // Called after the selected date changes.
    override func calendarView(_ calendarView: CalendarView, willSelect date: Date) {
        
    }
    
    // A row was selected in the events table. (Use this to push a details view or whatever.)
    override func calendarView(_ calendarView: CalendarView, didSelect event: CalendarEvent) {
        
    }
}

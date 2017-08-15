//
//  SwiftDemoViewController.swift
//  MBCalendarKit
//
//  Created by Moshe on 1/9/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

import UIKit
import MBCalendarKit

class SwiftDemoViewController: CKCalendarViewController
{
    
    var data : [Date:[CKCalendarEvent]] = [:]
    
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
        
        //
        //  Step 1 : Define some events
        //
        
        let title : NSString = NSLocalizedString("Add Swift Demo", comment: "") as NSString
        let date : Date = NSDate(day: 9, month: 1, year: 2015) as Date
        let event : CKCalendarEvent = CKCalendarEvent(title: title as String, andDate: date, andInfo: nil)
        
        let title2 : NSString = NSLocalizedString("Release MBCalendarKit 5.0.0", comment: "") as NSString
        let date2 : Date = NSDate(day: 15, month: 8, year: 2017) as Date
        let event2 : CKCalendarEvent = CKCalendarEvent(title: title2 as String, andDate: date2, andInfo: nil)
        
        
        //
        //  Step 2 : Add the events to the cache array
        //
        
        self.data[date] = [event]
        self.data[date2] = [event2]
    }

    //  MARK: - CKCalendarDataSource
    
    /**
     Allows the data source to supply events to display on the calendar.
     
     @param calendarView The calendar view instance that will display the data.
     @param date The date for which the calendar view wants events.
     @return An array of events objects.
     */
    override func calendarView(_ calendarView: CKCalendarView, eventsFor date: Date) -> [CKCalendarEvent] {
        
        let eventsForDate = self.data[date] ?? []
        
        return eventsForDate
    }
    
    // MARK: - CKCalendarDelegate 
    
    // Called before the selected date changes.
    override func calendarView(_ calendarView: CKCalendarView, didSelect date: Date) {
        super.calendarView(calendarView, didSelect: date) // Call super to ensure it 
    }
    
    // Called after the selected date changes.
    override func calendarView(_ calendarView: CKCalendarView, willSelect date: Date) {
        
    }
    
    // A row was selected in the events table. (Use this to push a details view or whatever.)
    override func calendarView(_ calendarView: CKCalendarView, didSelect event: CKCalendarEvent) {
        
    }
}

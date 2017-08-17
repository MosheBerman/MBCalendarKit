//
//  CKCustomCellDemoViewController.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit
import MBCalendarKit

class CKCustomCellDemoViewController: UIViewController, CustomCellProviding {
    
    private let calendarView = CalendarView(mode: .month)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.calendarView.customCellProvider = self
        
        self.installCalendar()
    }

    // MARK: - CustomCellProviding
    
    var customCellClass: AnyClass
    {
        return CustomCalendarCell.self
    }
    
    /**
     Called on the custom cell provider before
     
     @param calendarView The calendar view instance.
     @param cell The cell that will be used. If you registered a custom subclass, it will be of that class. If not, you will get a `CKCalendarCell` instance.
     @param context Some contextual information about the date represented by the cell.
     @param date The date being used for the calendar cell.
     */
    func calendarView(_ calendarView: CalendarView, willDisplay cell: UICollectionViewCell, in context: CalendarCellContext) {
        
        guard let cell = cell as? CustomCalendarCell else
        {
            return
        }
        
        cell.contextIdentifier = context.identifier
        
        let isWeekend = calendarView.calendar.isDateInWeekend(context.date)
        cell.isWeekend = isWeekend
        
        let dayOfMonth = calendarView.calendar.component(.day, from: context.date)
        cell.label.text = "\(dayOfMonth)"
    }
    
    // MARK: - Installing the Calendar
    
    func installCalendar()
    {
        self.view.addSubview(self.calendarView)
        self.calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self.calendarView,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.topLayoutGuide,
                           attribute: .bottom,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: self.calendarView,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
    }
}

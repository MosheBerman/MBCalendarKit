//
//  CKCustomCellDemoViewController.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit
import MBCalendarKit

class CKCustomCellDemoViewController: CalendarViewController, CustomCellProviding {



    internal var color: UIColor = UIColor.blue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.color = self.view.tintColor
        

        self.calendarView.customCellProvider = self
    }

    // MARK: - CustomCellProviding
    
    var customCellClass: AnyClass
    {
        return CalendarCell.self
    }
    
    /**
     Called on the custom cell provider before
     
     @param calendarView The calendar view instance.
     @param cell The cell that will be used. If you registered a custom subclass, it will be of that class. If not, you will get a `CKCalendarCell` instance.
     @param context Some contextual information about the date represented by the cell.
     @param date The date being used for the calendar cell.
     */
    @available(iOS 6.0, *)
    func calendarView(_ calendarView: CalendarView, willDisplayCell cell: CalendarCellBase, in context: CalendarCellContext) {
        
        guard let cell = cell as? CalendarCell else
        {
            return
        }
        
        cell.state = context.state
        
        // Step 1: Set the cell colors.
        self.setCellColors(cell: cell)
        
        // Step 2: Set the cell context.
        if context.isToday
        {
            cell.state = .today
        }
        
        let dayOfMonth = calendarView.calendar.component(.day, from: context.date)
        cell.number = NSNumber(value:dayOfMonth)
        
        if context.isSelected
        {
            cell.setSelected()
        }

    }
    
    func setCellColors(cell: CalendarCell)
    {
        cell.textColor = self.color
        cell.textSelectedColor = UIColor.white
        
        cell.todayTextColor = UIColor.white
        
        cell.inactiveSelectedBackgroundColor = self.color.withAlphaComponent(0.5)
        cell.selectedBackgroundColor = self.color.withAlphaComponent(0.75)
        cell.normalBackgroundColor = self.color.withAlphaComponent(0.1)
        
        cell.todayBackgroundColor = self.color
        cell.todaySelectedBackgroundColor = self.color
    }
}

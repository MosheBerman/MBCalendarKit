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
    func calendarView(_ calendarView: CalendarView, willDisplay cell: UICollectionViewCell, for date: Date, with context: CalendarCellContext) {
        
        guard let cell = cell as? CalendarCell else
        {
            return
        }
        
        // Step 1: Set the cell colors.
        self.setCellColors(cell: cell)
        
        // Step 2: Set the cell context.
        if context.isToday
        {
            cell.state = .todayDeselected
        }
        
        if !context.isInSameMonthAsToday
        {
            cell.textColor = self.color.withAlphaComponent(0.2)
        }
        
        if context.isAfterMaximumDate || context.isBeforeMinimumDate
        {
            cell.textColor = self.color.withAlphaComponent(0.1)
        }
        
        
        let dayOfMonth = calendarView.calendar.component(.day, from: date)
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
        
        cell.selectedBackgroundColor = UIColor.red
        cell.normalBackgroundColor = self.color.withAlphaComponent(0.1)
        cell.todayBackgroundColor = UIColor.blue
        cell.todaySelectedBackgroundColor = UIColor.red
    }
}

//
//  CustomWeekStartViewController.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/11/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

class CustomWeekStartViewController: UIViewController {
    
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var weekStartSegmentedControl: UISegmentedControl!
    
    private let calendar = NSCalendar.autoupdatingCurrent
    private let formatter = DateFormatter()
    
    
    // MARK: - The Weekday Names
    
    /// Returns a list of weekday names,
    /// formatted for the current locale.
    var weekdayNames: [String]
    {
        var names: [String] = []
        
        var components = DateComponents()
        components.calendar = self.calendar
        
        for dayIndex in 1...7
        {
            components.weekday = dayIndex
            components.month = 1
            components.year = 2017
            components.weekOfMonth = 1
            guard let date = self.calendar.date(from: components) else
            {
                print("Could not get date from components on calendar.")
                continue
            }
            
            let dayName = self.formatter.string(from: date)
            
            names.append(dayName)
        }
        
        return names
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureFormatter()
        self.configureSegmentedControl()
    }
    
    
    /// Set up the formatter for weekdays in the current locale
    private func configureFormatter()
    {
        self.formatter.calendar = self.calendar
        self.formatter.setLocalizedDateFormatFromTemplate("ccc")
    }

    
    // MARK: - Configuring the Segmented Control
    
    private func configureSegmentedControl()
    {
        self.weekStartSegmentedControl.removeAllSegments()
        
        for day in self.weekdayNames
        {
            self.weekStartSegmentedControl.insertSegment(withTitle: day, at: Int.max, animated: false)
        }
        
        self.weekStartSegmentedControl.addTarget(self, action: #selector(updateWeekStart), for: .valueChanged)
        
        self.weekStartSegmentedControl.selectedSegmentIndex = self.calendar.firstWeekday - 1
    }
    
    // MARK: - Updating the Day Of the Week
    
    @objc private func updateWeekStart()
    {
        self.calendarView.firstWeekDay = UInt(self.weekStartSegmentedControl.selectedSegmentIndex) + 1
    }
    

}

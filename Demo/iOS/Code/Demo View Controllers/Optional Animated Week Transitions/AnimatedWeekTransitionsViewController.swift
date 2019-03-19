//
//  AnimatedWeekTransitionsViewController.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/11/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

class AnimatedWeekTransitionsViewController: UIViewController {

    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureCalendar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

// MARK: - Configuring the Calendar
    
    private func configureCalendar()
    {
        self.calendarView.displayMode = .week
        self.calendarView.animatesWeekTransitions = true
    }

}

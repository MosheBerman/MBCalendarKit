//
//  VisibleDateViewController.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 9/5/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit
import MBCalendarKit

class VisibleDateViewController: UIViewController {

    @IBOutlet weak var calendarView: CalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.calendarView.updatesSelectedDateBasedOnVisibleDate = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

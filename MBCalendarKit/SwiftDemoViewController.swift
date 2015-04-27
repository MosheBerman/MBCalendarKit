//
//  SwiftDemoViewController.swift
//  MBCalendarKit
//
//  Created by Moshe on 1/9/15.
//  Copyright (c) 2015 Moshe Berman. All rights reserved.
//

import UIKit

class SwiftDemoViewController: CKDemoViewController, CKCalendarViewDataSource{
    
    var data : NSMutableDictionary
    
   init() {
        self.data = NSMutableDictionary()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder aDecoder: NSCoder) {
        
        data = NSMutableDictionary()
        
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        
        self.data = NSMutableDictionary()
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
        
        let title : NSString = NSLocalizedString("Add Swift Demo", comment: "")
        let date : NSDate = NSDate(day: 9, month: 1, year: 2015)
        let event : CKCalendarEvent = CKCalendarEvent(title: String(title), andDate: date, andInfo: nil)
        
        
        //
        //  Step 2 : Add the events to the cache array
        //
        
        self.data[date] = [event]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //
    //  MARK: - CKCalendarDataSource
    //
    
    func calendarView(calendarView: CKCalendarView!, eventsForDate date: NSDate!) -> [AnyObject]! {
        
        return self.data.objectForKey(date) as! [AnyObject]
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

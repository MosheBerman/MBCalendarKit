//
//  DemoRootTableViewController.swift
//  MBCalendarKit Demo
//
//  Created by Moshe Berman on 8/7/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

class DemoRootTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.title = NSLocalizedString("Features", comment: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        guard let cell = sender as? UITableViewCell else
        {
            return
        }
        
        segue.destination.title = cell.textLabel?.text
        
    }
}

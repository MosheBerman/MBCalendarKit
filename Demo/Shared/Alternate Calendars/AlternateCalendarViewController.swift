//
//  AlternateCalendarViewController.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/16/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit
import MBCalendarKit

class AlternateCalendarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    /// The picker for picking calendars.
    @IBOutlet weak var calendarPicker: UIPickerView!
    
    // The calendar view.
    @IBOutlet weak var calendarView: CalendarView!
    
    
    private let viewModel = AlternateCalendarViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       self.installPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 
    
    func installPicker()
    {
        self.calendarPicker.dataSource = self
        self.calendarPicker.delegate = self
    }

    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.title(for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     let identifier = self.viewModel.identifier(for: row)
        let calendar = Calendar(identifier: identifier)
     
        self.calendarView.calendar = calendar
    }
    
    // MARK: - UIPickerDataSource
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.identifiers.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func localeToggleChanged(_ sender: UISegmentedControl)
    {
        
    }
    
}

//
//  RTLDemo.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/15/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

class RTLDemo: CalendarViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.forceRTL()
    }
    
    /// Force 
    func forceRTL()
    {
        if #available(iOS 9.0, *) {
            self.calendarView.semanticContentAttribute = .forceRightToLeft
            self.calendarView.locale = Locale(identifier: "he")
        } else {
            self.informUserAboutDemoRequirement()
        }
    }
    
    func informUserAboutDemoRequirement()
    {
        let title = NSLocalizedString("iOS 8", comment: "")
        let message = NSLocalizedString("This demo requires iOS 9.0 or higher, because it relies on semanticContentAttribute. To see right-to-left support, change your device's language in Settings.app and then come back.", comment: "A note about RTL demo not being supported on iOS 8.")
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let openSettings = UIAlertAction(title: "Settings", style: .default) { (action: UIAlertAction) in
            let url = URL(string:UIApplicationOpenSettingsURLString)!
            UIApplication.shared.openURL(url)
        }
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(ok)
        alertController.addAction(openSettings)
        alertController.modalTransitionStyle = .coverVertical
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}

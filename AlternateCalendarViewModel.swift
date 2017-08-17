//
//  AlternateCalendarViewModel.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/16/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

class AlternateCalendarViewModel: NSObject {
    
    // MARK: -
    
    private let locale = NSLocale.autoupdatingCurrent
    let identifiers: [Calendar.Identifier] = [
        .gregorian,
        .buddhist,
        .chinese,
        .coptic,
        .ethiopicAmeteMihret,
        .ethiopicAmeteAlem,
        .hebrew,
        .iso8601,
        .indian,
        .islamic,
        .islamicCivil,
        .japanese,
        .persian,
        .republicOfChina,
        .islamicTabular,
        .islamicUmmAlQura
    ]
    
    
    
    // MARK: -
    
    func title(for row: NSInteger) -> String
    {
        var title = ""
        
        let identifier = self.identifiers[row]
        
        if let t = self.locale.localizedString(for: identifier)
        {
            title = t
        }
        else
        {
            title = "\(identifier)"
        }
        
        return title
    }
    
    // MARK: - Calendar Identifier
    
    func identifier(for row: NSInteger) -> Calendar.Identifier
    {
        return self.identifiers[row]
    }
}

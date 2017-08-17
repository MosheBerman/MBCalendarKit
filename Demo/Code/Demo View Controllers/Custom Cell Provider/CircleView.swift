//
//  CircleView.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/16/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit

class CircleView: UIView {

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        self.layer.cornerRadius = min(self.bounds.size.width, self.bounds.size.height) / 2.0
        self.backgroundColor = UIColor(red: 1.0, green: 0.1, blue: 0.1, alpha: 1.0)
        self.layer.masksToBounds = true
    }
    
    // MARK: - Autolayout
    open class var requiresConstraintsBasedLayout: Bool {
        return true
    }

}

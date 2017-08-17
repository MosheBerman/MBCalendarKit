//
//  CustomCalendarCell.swift
//  MBCalendarKit
//
//  Created by Moshe Berman on 8/16/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import UIKit
import MBCalendarKit

class CustomCalendarCell: UICollectionViewCell {

    // MARK: - Internal Views
    
    private let circle = CircleView()
    private(set) var label = UILabel()
    private let topBorder = UIView()
    
    public var contextIdentifier: CalendarCellContextIdentifier = .default {
        didSet {
            self.updateColors()
        }
    }
    
    public var isWeekend: Bool = false {
        didSet {
            self.updateColors()
        }
    }
    
    
    // MARK: - Setting Up Highlighting
    
    override var isHighlighted: Bool {
        didSet {
            self.updateColors()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.updateColors()
        }
    }
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.installSubviews()
        self.contentView.backgroundColor = UIColor.white
        self.topBorder.backgroundColor = UIColor(white: 0.8, alpha: 0.5)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Some Styling Computation
    
    /// The circle should be empty, unless the cell represents today, or is highlighted or selected.
    private var circleBackgroundColor: UIColor {
        var color = UIColor.clear
        
        if self.isSelected  {
            if self.contextIdentifier == .today {
                color = UIColor.red
            }
            else {
                color = UIColor.black
            }
        }
        
        if self.isHighlighted {
            color = UIColor(white: 0.8, alpha: 1.0)
            
            if self.contextIdentifier == .today {
                color = UIColor.red.withAlphaComponent(0.2)
            }
        }
        
        return color
    }
    
    
    /// Text labels should be black, unless
    private var textLabelColor: UIColor {
        var color = UIColor.black
        
        if self.circleBackgroundColor != UIColor.clear {
            color = UIColor.white
        }
        else if self.contextIdentifier == .outOfCurrentScope {
            color = UIColor(white: 0.9, alpha: 0.5)
        }
        else if self.contextIdentifier == .today {
            color = UIColor.red
        }
        else if self.isWeekend {
            color = UIColor.lightGray
        }
        
        return color
    }
    
    
    /// This method applies the colors when it is called.
    private func updateColors() {
        self.circle.backgroundColor = self.circleBackgroundColor
        self.label.textColor = self.textLabelColor
    }
    
    // MARK: - Setting Up the View Hierarchy
    
    /// This method installs the subviews and sets up constraints.
    func installSubviews() {
        self.install(circle: self.circle)
        self.install(label: self.label)
        self.installUpperBorder()
        
        self.label.textAlignment = .center
    }
    
    
    /// This method installs the label view.
    ///
    /// - Parameter label: The label to install.
    func install(label: UILabel) {
        self.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: label,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: label,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: label,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .height,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: label,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .width,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
    }
    
    
    /// This method installs the circle view.
    ///
    /// - Parameter circle: The circle to install.
    func install(circle: CircleView)
    {
        self.contentView.addSubview(circle)
        circle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: circle,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: circle,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .centerY,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: circle,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 34.0).isActive = true
        
        NSLayoutConstraint(item: circle,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: circle,
                           attribute: .height,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
    }
    
    func installUpperBorder()
    {
        self.topBorder.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.topBorder)
        
        NSLayoutConstraint(item: self.topBorder,
                           attribute: .top,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .top,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: self.topBorder,
                           attribute: .width,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .width,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: self.topBorder,
                           attribute: .height,
                           relatedBy: .equal,
                           toItem: nil,
                           attribute: .notAnAttribute,
                           multiplier: 1.0,
                           constant: 1.0/UIScreen.main.scale).isActive = true
        
        NSLayoutConstraint(item: self.topBorder,
                           attribute: .centerX,
                           relatedBy: .equal,
                           toItem: self.contentView,
                           attribute: .centerX,
                           multiplier: 1.0,
                           constant: 0.0).isActive = true
    }

}

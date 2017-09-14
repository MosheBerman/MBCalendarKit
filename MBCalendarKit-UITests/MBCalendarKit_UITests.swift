//
//  MBCalendarKit_UITests.swift
//  MBCalendarKit-UITests
//
//  Created by Moshe Berman on 9/14/17.
//  Copyright © 2017 Moshe Berman. All rights reserved.
//

import XCTest


/// This test bundle ensures basic UI functionality of the framework:
/// - Displaying the Gregorian calendar.
/// - Displaying each of the modes.
class MBCalendarKit_UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Test Delegate Methods
    
    /// I think that the way we would test this is
    /// to open the demo app, then tap on the first
    /// row.
    /// Then we can ensure that the calendar
    /// is visible. Either by tapping it, or
    /// by using some XCTest method.
    func testDisplayOfGregorianCalendar() {
        XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["Objective-C Calendar Control"]/*[[".cells.staticTexts[\"Objective-C Calendar Control\"]",".staticTexts[\"Objective-C Calendar Control\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        
    }
    
}

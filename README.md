MBCalendarKit
================

Description:
------------

MBCalendarKit is a calendar control written in UIKit. I've found kal and Tapku's implementations to be inadequate and difficult to work with, so I rolled my owne.

![Month](./screens/month.png "Month View")
![Week](./screens/week.png "Week View")
![Delegate](./screens/day.png "Day View")

Dependencies:
-------------

You'll need the iOS 6 SDK. I haven't tested it against earlier versions of iOS. Your mileage may vary on iOS 5, and it definitely will not work on iOS 4 or earlier.

MBCalendarKit requires Quartz, Core Graphics, UIKit, and Foundation. The Unit Tests build against the SenTestingKit framework. Xcode should take care of all those except `QuartzCore.framework` and `SenTestingKit.framework`. Make sure to link those two yourself.

Relevant Files:
---------------

Aside from the framework dependencies described above, you'll want everything in the CalendarKit folder. 

Showing a Calendar
--------------------------------------

You have two choices for showing a calendar using MBCalendarKit. 

1. You can show an instance of `MBCalendarView`. Use this if you want to manually manage your view hierarchy.
2. Your second option is to subclass `MBCalendarViewController`. This gives you the added benefit of a "today" button and a segmented control in the toolbar, which allows you to select the display mode.
 


Thanks:
-------
Dave DeLong, for being an invaluable reference.

License:
========

MBCalendarKit is hereby released under the MIT License. 

Copyright (c) 2013 Moshe Berman

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

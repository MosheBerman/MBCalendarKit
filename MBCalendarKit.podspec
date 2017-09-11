Pod::Spec.new do |s|

  s.name         = "MBCalendarKit"
  s.version      = "5.1.0"
  s.summary      = "An open source calendar library for iOS."
  s.description  = <<-DESC
	MBCalendarKit is a calendar library for iOS. It offers a flexible calendar control, with support  for displaying any calendar system supported by `NSCalendar`. It also includes an API to  customize the calendar cells. Recently rewritten, it now has first-class support for Swift interoperability. It also ships with a prebuilt view controller, inspired by the original iOS calendar. For a full list of features, check out the Readme.
                   DESC
  s.homepage     = "https://github.com/MosheBerman/MBCalendarKit"
  s.screenshots  = "https://raw.github.com/MosheBerman/MBCalendarKit/master/Promo/Screenshots/month.png","https://raw.github.com/MosheBerman/MBCalendarKit/master/Promo/Screenshots/week.png",
"https://raw.github.com/MosheBerman/MBCalendarKit/master/Promo/Screenshots/day.png"
  s.author       = { "Moshe Berman" => "moshberm@gmail.com" }
  s.license 	 = 'MIT'
  s.platform     = :ios, '8.0'
  s.source       = { :git => "https://github.com/MosheBerman/MBCalendarKit.git", :tag => s.version.to_s} 
  s.source_files  = 'Classes', 'MBCalendarKit/CalendarKit/**/*.{h,m}'
  s.frameworks = 'QuartzCore'
  s.requires_arc = true
end

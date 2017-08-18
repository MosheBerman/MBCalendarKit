# Contributing to MBCalendarKit

Thanks for your interest in contributing to `MBCalendarKit`. The purpose of this document is to make your life easier, and to help you get the features you want out of this project. With that in mind, let's get to it.

- [Filing a Bug](#filing-a-bug)
- [Suggesting New Features](#suggesting-new-features)
- [Contributing](#contributing)

## Filing a Bug

This is a hobby project, not my main job, so I can't guarantee a timely response to every issue. That said, I do receive alerts on this repository and am happy to assist if I can. So...

- If you are trying to integrate MBCalendarKit into your project and it's harder than it should be, please open an issue. 
- Before you open an issue, try searching the open issues list to see if there's something already there. (If there is and you happen to miss it, no worries.)
- Please follow the issue template: Summary, Steps to Reproduce, Expected Behavior, Actual Behavior, and add some information about your setup in the notes. I may ask for follow up, including logs and screenshots. (Please do not post private information, such as unreleased product names.)
- English is my primary language, so if your issue is not written in English, it may take me some more time to help out. (I'll try to use Google Translate, but if you need an answer quickly, well formed English is your best bet.)
- Finally, please tag your issue with one of the existing tags, at least either `bug` or `enhancement`. 
- I may add a tag later with a version number, corresponding to an upcoming library release that I'd like to add the change to.  (That tag isn't a commitment to the fix, just an aspiration.)


## Suggesting New Features
If you have an idea for a feature, I'd love to hear it! MBCalendarKit has had half-a-dozen contributors, and I'd be really happy to increase that number.


## Contributing
If you want to contribute, please take a look at the issues list for an issue tagged [`help-wanted`](https://github.com/MosheBerman/MBCalendarKit/issues?q=is%3Aissue+is%3Aopen+label%3Ahelp-wanted). These are the things I care about when it comes to contributing:

- **Language:** The core library is pure Objective-C, to avoid requiring bundling Swift runtime along with it, so please work in Obj-C.
- **Style:** I'm not huge on style guide debates, but for consistency within the codebase, use dot syntax and modern Objective-C best practices where you can. Also braces on their line.
- **Issue Tracking & Discussion** Please make sure there's a corresponding issue for your work, even if it's an enhancement.
- **Unit Tests:** The project has a test target and is set up to work with BuddyBuild. There aren't enough tests at the moment, but please do your best to test new changes.

Thank you!
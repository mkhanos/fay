# Video Demo
https://www.loom.com/share/e6731edf22204a52a443fbab8b318711
# Implementation Notes/Decisions Made
* Mimicked the design system for fonts and colors from figma to allow for developers to EASILY implement new view components with convenience modifiers that would be relative to system defined font sizes
* Explicitly throwing errors and making the caller handle them at the view model level. I did not get to implement robust alerts in 6 hours
* Used singleton to inject auth and the network client throughout the app. Decided for a small project it would be ok, but using a library like SWInject would be better for a LARGER project
* Kept view models in their view files as an extension to REDUCE number of files and names to keep track of. For a small project/few views it's fine but at 10 or more views I think it would be hard to maintain
* Developed for min target iOS 18 mainly to use NEW scroll view api functions. The tab view in figma would NOT look good on Liquid Glass, so no iOS 26. If the appointment lists had more items, the user would get a snappy scrolling experience. 
* Separated network requests from network calls from view models. THEORETICALLY this would allow for better testing/injection. I did not have time to get to making my own mocks or protocols for tests.
* Initially I made this a SwiftData project because I thought it would be COOL to SAVE appointments in the app's storage, but due to TIME I removed it. In the real world this might make tracking appointment changes MORE overhead than it's worth since you'd be updating a local data container with whatever the network returns.


# Time Breakdown 
* Login Screen: 30 minutes 
* Appointments Screen: 4 hours
* Additional time:
  * Network Boilerplate: 20 minutes
  * Hooking up auth and appointments: 20 minutes
  * Convenience modifiers for fonts: 10 minutes
  * Adding colors and icons to asset catalog: 5 minutes
  * Tab View: 30 minutes


PS: I hope you're reading this Kyle and appreciated the CAPITALIZATION. 

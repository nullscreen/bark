<p align="center" >
  <img src="http://i.imgur.com/fkR8t4g.png" alt="BARK" title="BARK">
</p>

BARK (Better App Reporting Kit) is a simple, in-app issue reporting library for iOS. Shaking the app pulls up an action sheet, where beta users can instantly send email or create GitHub issues.
<p align="center">
<img src="http://i.imgur.com/Tge4KbW.png" alt="action sheet" title="action sheet" width="300" height="564">
<img src="http://i.imgur.com/iu0iydA.png" alt="issue view" title="issue view" width="300" height="564">
</p>
## Get Started ##

1. Add BARK to your Podfile `pod 'Bark', '~> 0.1'` or clone the repository with `git clone git@github.com:stagebloc/bark.git` 
2. Link the following frameworks in the Build Phases tab: 
    - `MessageUI` - to send emails from within the app
    - `SystemConfiguration` -  for network reachability support
    - `Security` - for secure storage of GitHub credentials
3. In your `AppDelegate.m`, `#import "SBWindow.h"`
4. Finally, set `self.window` equal to the SBWindow subclass, as shown below - make sure to set `window.repositoryName` to the name of the repository you want to submit issues to.

```objc
// an example applicationdidFinishLaunchingWithOptions method
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    SBWindow *window = [[SBWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.repositoryName = @"stagebloc/bark";
    self.window = window;
    
    // Override point for customization after application launch.
    SBRootViewController *rootViewController = [[SBRootViewController alloc] init];
    self.window.rootViewController = rootViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
```

## Features ##

BARK comes with a set of features to make quick adjustments. You can set these below `repositoryName` on the window object.

```objc
// email
window.emailRecipients = @[@"hi@stagebloc.com", @"ratchet@stagebloc.com"];
window.emailSubject = @"Subject";
window.emailBody = @"Body"; // note that this will override sending device info
window.attachScreenshot = YES; // defaults to YES

// github
window.defaultAssignee = @"your_username";
window.defaultMilestone = @"milestone_title";
window.attachDeviceInfo = YES; // defaults to YES
```

### Coming Soon ###

Submitting images through the GitHub API is currently unsupported. We're planning to build a workaround to make this possible, so you'll soon be able to attach screenshots to GitHub issues as well.

## Using BARK in Production ##

BARK can now be used in production by implementing a simple callback.

1) Add the `SBWindowDelegate` to your `AppDelegate.h` file. 

```objc
#import "SBWindow.h"
@interface SBAppDelegate : UIResponder <UIApplicationDelegate, SBWindowDelegate>
```
2) Set the delegate property on your `SBWindow` instance in your `AppDelegate.m` file. Note that the property is called `windowDelegate` as opposed to `delegate`. This is to avoid interfering with the `delegate` property on the `UIWindow` superclass.

```objc
window.windowDelegate = self;
```
3) Implement the delegate method `shouldShowActionSheet`. You'll need to create your own way of determining whether or not the current user is an admin. We check against the logged in user's email address.

```objc
- (BOOL)shouldShowActionSheet
{
    /* add the logic to determine whether or not to show the action sheet. Something like:
     if([currentUser isAdmin]) {
        return YES;
     } else return NO;
    */
    return YES;
}
```

## License ##

BARK is published under the MIT License (MIT)

Copyright (c) 2013 StageBloc

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

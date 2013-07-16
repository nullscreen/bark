<p align="center" >
  <img src="http://i.imgur.com/fkR8t4g.png" alt="AFNetworking" title="AFNetworking">
</p>

Bark is a simple, in-app issue reporting library for iOS. By default, shaking the app pulls up an action sheet, where beta testers can instantly send an email or create an issue on GitHub.

## Get Started ##

1. Clone the repository with `git clone git@github.com:stagebloc/bark.git`
2. Link the following frameworks in the Build Phases tab: 
    - `MessageUI` - to send emails from within the app
    - `SystemConfiguration` -  for network reachability support
    - `Security` - for secure storage of GitHub credentials
3. In your AppDelegate, `#import "SBWindow.h`
4. Set `self.window` equal to the SBWindow subclass, as shown below.

```objc
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

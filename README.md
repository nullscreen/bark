# ALReporter #

ALReporter is drop-in bug reporting library for iOS. Shaking the app pulls up an action sheet, where beta users can instantly send an email or create an issue on GitHub.

## Installation ##

1. Clone the repository with `git clone git@github.com:austinlouden/ALReporter.git`
2. Link the `MessageUI` and `SystemConfiguration` frameworks in the Build Phases tab.
3. In your AppDelegate, `#import "ALWindow.h`
4. Set `self.window` equal to the ALWindow subclass.


```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ALWindow *window = [[ALWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.repositoryName = @"ALReporter";
    self.window = window;
    
    // Override point for customization after application launch.
    ALRootViewController *rootViewController = [[ALRootViewController alloc] init];
    self.window.rootViewController = rootViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
```

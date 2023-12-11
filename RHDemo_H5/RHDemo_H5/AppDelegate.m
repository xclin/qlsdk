

#import "AppDelegate.h"
#import <QLTranslate/QLTranslate.h>
#import "ViewController.h"
@interface AppDelegate ()
@property (nonatomic, strong) ViewController *rootVC;
@end
@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.rootVC = [[ViewController alloc] init];
    self.window.rootViewController = self.rootVC;
    [self.window makeKeyAndVisible];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    return [[QLGameManager shared] application:application didFinishLaunchingWithOptions:launchOptions];
}

#pragma mark - 支付回调，必接

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [[QLGameManager shared] application:application openURL:url options:options];
}
#else
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[QLGameManager shared] application:application openURL:url  sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[QLGameManager shared] application:application handleOpenURL:url];
}

#endif

- (void)applicationWillResignActive:(UIApplication *)application {
    [[QLGameManager shared] applicationWillResignActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[QLGameManager shared] applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[QLGameManager shared] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[QLGameManager shared] applicationDidBecomeActive:application];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[QLGameManager shared] applicationWillTerminate:application];
}


@end

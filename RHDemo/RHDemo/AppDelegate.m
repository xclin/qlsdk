

#import "AppDelegate.h"
#import <QLTranslate/QLTranslate.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES; //[[QLGameManager shared] application:application didFinishLaunchingWithOptions:launchOptions];
}

#pragma mark - 支付回调，必接

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    return [[QLGameManager shared] application:application openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[QLGameManager shared] application:application openURL:url  sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[QLGameManager shared] application:application handleOpenURL:url];
}



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

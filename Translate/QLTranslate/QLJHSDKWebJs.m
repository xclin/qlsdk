
#include <CommonCrypto/CommonCrypto.h>
#import "QLJHSDKWebJs.h"
#import <AdSupport/AdSupport.h>
#import "QLsdkInitConfiger.h"
#import "QlDeviceUtils.h"
#import "QLsdkLoginConfiger.h"
#import "QLGameManager.h"
#import "QLApiGame.h"
#import "QlRequestUtils.h"
#import "QlEncryptUtils.h"
#import "NSMutableDictionary+QLValueNonnull.h"

#define MAIN_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAIN_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

static QLJHSDKWebJs * sharedSingleton = nil;

@interface QLJHSDKWebJs ()

@end

@implementation QLJHSDKWebJs

+ (instancetype)sharedSingleton {
    static dispatch_once_t pred;
    dispatch_once(&pred,^{
        if (sharedSingleton == nil) {
            sharedSingleton = [[self alloc] init];
        }
    });
    return sharedSingleton;
}

- (void)removeScriptMessage:(WKWebView *)webView{
    //这里需要注意，前面增加过的方法一定要remove掉。
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"loginAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"serviceAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"updateAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"purchaseAction"];
    [webView.configuration.userContentController removeScriptMessageHandlerForName:@"logoutAction"];
}

- (WKWebViewConfiguration *)webViewConfiguration{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    WKUserContentController *userCC = config.userContentController;
    [userCC addScriptMessageHandler:self name:@"loginAction"];
    [userCC addScriptMessageHandler:self name:@"serviceAction"];
    [userCC addScriptMessageHandler:self name:@"updateAction"];
    [userCC addScriptMessageHandler:self name:@"purchaseAction"];
    [userCC addScriptMessageHandler:self name:@"logoutAction"];
    config.userContentController = userCC;
    return config;
}

- (WKWebView *)getJSWebView{
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT) configuration:self.webViewConfiguration];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = NO;
    webView.scrollView.alwaysBounceVertical = NO;
    webView.scrollView.alwaysBounceHorizontal = NO;
    webView.scrollView.bounces = NO;
    //iphoneX安全区域适配
    //    if (@available(iOS 11.0, *)) {
    //        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    //    }
    return webView;
}

- (void)loadRequest:(WKWebView *)webView{
    NSString *url = [NSString stringWithFormat:@""];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:request];
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSDictionary *dict;
    NSError *err;
    if ([message.name isEqualToString:@"loginAction"]) {
        [[QLGameManager shared] loginSDK];//
    }else if ([message.name isEqualToString:@"serviceAction"]){
        if ([message.body isKindOfClass:[NSString class]]){
            NSData *jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
            dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
        }else if ([message.body isKindOfClass:[NSDictionary class]]){
            
            NSData *data = [NSJSONSerialization dataWithJSONObject:message.body options:0 error:NULL];
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
            NSLog(@"选服--NSDictionary-=%@",dict);
        }
        
        NSDictionary *jsonDict = [dict objectForKey:@"json"];
          
        
    }else if ([message.name isEqualToString:@"updateAction"]){
        
    }else if ([message.name isEqualToString:@"purchaseAction"]){
        if ([message.body isKindOfClass:[NSString class]]){
            NSData *jsonData = [message.body dataUsingEncoding:NSUTF8StringEncoding];
            dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            NSLog(@"购买-NSString-=%@",dict);
        }else if ([message.body isKindOfClass:[NSDictionary class]]){
            NSData *data = [NSJSONSerialization dataWithJSONObject:message.body options:0 error:NULL];
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        }
        NSDictionary *jsonDict = [dict objectForKey:@"json"];

            

    }else if ([message.name isEqualToString:@"logoutAction"]){
        NSLog(@"注销");
        [[QLGameManager shared] logoutSDK];
    }
}

- (NSString *)toStr:(id)sender {
      return [NSString stringWithFormat:@"%@",sender?sender:@""];
}

#pragma mark sign
- (NSString *)sign {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSString *sign = [QlDeviceUtils compareWithNSDictionary:dict].md5String;
    return sign;
}

//获取当前UIViewController
- (UIViewController *)topViewController {
    UIViewController *resultVC;
    resultVC = [self _topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}

@end


#import "UIKit/UIKit.h"
#import "QLsdkInitConfiger.h"
#import "QlDeviceUtils.h"
#import "NSMutableDictionary+QLValueNonnull.h"
#import <AdSupport/AdSupport.h>
#import<AdSupport/ASIdentifierManager.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import "QLEventsListener.h"
static QLsdkInitConfiger * shareConfigerManager = nil;
@implementation QLsdkInitConfiger

+ (instancetype)share{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        if (shareConfigerManager == nil) {
            shareConfigerManager = [[self alloc]init];
            [QLsdkInitConfiger getInfoPlist];
        }
    });
    return shareConfigerManager;
}

#pragma mark 获取渠道ID
+ (void)getInfoPlist {
    NSString * path = @"QiLinSDKInfo.plist";
    NSString *pat = [[NSBundle mainBundle] bundlePath] ;
    NSString *textPath = [NSString stringWithFormat:@"%@/%@",pat,path];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithContentsOfFile:textPath];
    shareConfigerManager.appid = [dict objectForKey:@"appid"];
    shareConfigerManager.appKey = [dict objectForKey:@"appKey"];
    shareConfigerManager.gameid = [dict objectForKey:@"gameid"];
    shareConfigerManager.channel_mark = [dict objectForKey:@"channel_mark"];//渠道名
    shareConfigerManager.showBug = [[dict objectForKey:@"showBug"] boolValue];//是否开启日志
    shareConfigerManager.equipmentIDFA = [self getEquipmentIDFA];
    if (dict.allValues.count > 0) {
        //表示已经配置
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"配置文件有误" message:@"请配置 QiLinSDKInfo.plist" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [[self getCurrentRootViewController ] presentViewController:alert animated:true completion:nil];
        
    }
}

#pragma mark - private
+ (UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if (topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"SCould not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    return result;
}




//获取广告标识
+ (NSString *)getEquipmentIDFA{
    
 __block   NSString * idfaString = @"00000000-0000-0000-0000-000000000000";
    if (@available(iOS 14, *)) {
            // iOS14及以上版本需要先请求权限
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // 获取到权限后，依然使用老方法获取idfa
                if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                    idfaString = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                    NSLog(@"idfaString%@",idfaString);
                } else {
                         NSLog(@"请在设置-隐私-跟踪中允许App请求跟踪");
                }
            }];
        } else {
            // iOS14以下版本依然使用老方法
            // 判断在设置-隐私里用户是否打开了广告跟踪
            if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                idfaString = [[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
                NSLog(@"%@",idfaString);
            } else {
                NSLog(@"请在设置-隐私-广告中打开广告跟踪功能");
            }
        }
    
    return idfaString;
}

@end

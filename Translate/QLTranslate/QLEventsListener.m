
#import "QLEventsListener.h"
#import "QLNotificationList.h"
#import "QLApiGame.h"
#import "QLsdkInitConfiger.h"
#import "QLsdkLoginConfiger.h"
#import "NSMutableDictionary+QLValueNonnull.h"
#import "QLsdkRoleConfiter.h"
#import "QlRequestUtils.h"
@implementation QLEventsListener

static QLEventsListener *eventsListener = nil;
+ (instancetype)shared {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (eventsListener == nil) {
            eventsListener = [[self alloc]init];
        }
    });
    return eventsListener;
}


- (void)startListen {
    NSLog(@"startListen");

}

/// 回调给游戏
/// @param notiName 通知名称
/// @param info 信息
+ (void)callBackToGameWithNotiName:(NSString *)notiName info:(NSDictionary *)info {
    [[NSNotificationCenter defaultCenter] postNotificationName:notiName object:nil userInfo:info];
}

+ (NSMutableDictionary *)callBackParamsWithMsg:(NSString *)msg code:(NSString *)code data:( NSDictionary *)data {
    NSMutableDictionary *muDict = [[NSMutableDictionary alloc] init];
    [muDict setSafeValue:msg forKey:@"msg"];
    [muDict setSafeValue:code forKey:@"code"];
    if (data) {
        [muDict setSafeValue:data forKey:@"data"];
    }
    return muDict;
}

+ (void)postMeshCheck:(NSString*)meshName{
    if ([QLsdkInitConfiger share].showBug){
        NSLog(@"%@",meshName);
        NSDictionary * content = @{@"content":[NSString stringWithFormat:@"ios-%@:%@",[self getAppName],meshName]};
        NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithDictionary:content];
        [dic setValue:@"text" forKey:@"msgtype"];
        NSString *url = [NSString stringWithFormat:@"https://oapi.dingtalk.com/robot/send?access_token=cd6619f064d778b2c616a7e2a91fefd2ee423ec86c07f8c725cf5cf8a7ede6df"];
        [QlRequestUtils postWithUrl:url parms:dic timeout:10 succeed:^(NSDictionary * _Nonnull responseObject) {
            NSLog(@"responseObject--%@",responseObject);
        } failure:^(NSString * _Nonnull errMsg) {
            NSLog(@"errMsg--%@",errMsg);
        }];
        
    }
}


#pragma  mark 获取游戏名称
+ (NSString *)getAppName{
    NSDictionary *infoDictionary =[[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return app_Name;
    
}

@end

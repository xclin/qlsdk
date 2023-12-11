

#import "QLGameManager.h"
#import "QLEventsListener.h"
#import "QLApiGame.h"
#import "QLsdkInitConfiger.h"
#import "QlDeviceUtils.h"
#import <SafariServices/SafariServices.h>
#import "QLsdkLoginConfiger.h"
#import "QLJHSDKWebJs.h"
#import "QLUrlList.h"
#import "NSMutableDictionary+QLValueNonnull.h"
#import "QLsdkRoleConfiter.h"
#import "QLNotificationList.h"
#import "QLsdkPayConfiter.h"
#import "QLprivateView.h"
#import <YiYouSDK/YiYouSDK.h>
@interface QLGameManager () <UIWebViewDelegate,NSURLConnectionDataDelegate,SFSafariViewControllerDelegate,WKNavigationDelegate,WKUIDelegate,privateViewDelegate>
@property (nonatomic,strong) QLprivateView *pView;
@end

@implementation QLGameManager

static QLGameManager *gmaeManager = nil;
+ (instancetype)shared {
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (gmaeManager == nil) {
            gmaeManager = [[self alloc]init];
        }
    });
    return gmaeManager;
}

- (instancetype)init {
    if (self = [super init]) {
        [[QLEventsListener shared] startListen];
    }
    return self;
}


- (QLprivateView *)pView{
    if (!_pView) {
        _pView  = [ QLprivateView new];
        _pView.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
        _pView.delegate = self;
    }
    return _pView;
}

- (NSString*) uid {
    
    return [QLsdkLoginConfiger share].s_uid;
}

- (NSString*) accountName {
    
    return [QLsdkLoginConfiger share].username;
}

- (NSString*) token {
    
    return [QLsdkLoginConfiger share].user_Token;
}



#pragma mark - 初始化

- (void)initSDK {
    
    
    [QLEventsListener postMeshCheck:[NSString stringWithFormat:@"开始初始化聚合SDK：appId:%@,appkey:%@,gameID:%@,channel_mark:%@",[QLsdkInitConfiger share].appid,[QLsdkInitConfiger share].appKey,[QLsdkInitConfiger share].gameid,[QLsdkInitConfiger share].channel_mark]];
    
    
    BOOL isdif = [[NSUserDefaults standardUserDefaults] boolForKey:@"didFinishLaunchingWithOptions"];
    //初始化
    if (!isdif) {//如果研发没接入
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"注意" message:@"请接入系统函数 didFinishLaunchingWithOptions" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [[self getCurrentRootViewController ] presentViewController:alert animated:true completion:nil];
      
    }else{
        //渠道初始化成功回调
        [QLEventsListener callBackToGameWithNotiName:QLInitNotification info:[QLEventsListener callBackParamsWithMsg:@"初始化成功" code:@"1" data:nil]];
        //TODO 渠道初始化，（不固定位置初始化）
        
        [YiYouSDK_Kit sharedInstance].AYLoginSuccessBack = ^(NSString *paramToken, NSString *userName, NSString *time, NSString *sign) {
            NSLog(@"登录成功返回Token：%@  \n 用户名:%@",paramToken,userName);
            //add
            [QLEventsListener postMeshCheck:[NSString stringWithFormat:@"收到渠道登录返回的Token：%@  \n 用户名:%@",paramToken,userName]];
     
            //渠道登录回调之后，再登录我们这边的服务器校验（注意：需要在渠道SDK 登录接口回调进行下面操作，其他接口同理）
            [QLsdkLoginConfiger share].channel_user_Token = paramToken;//渠道的token
            [QLsdkLoginConfiger share].channel_username = userName;//渠道的username
            //渠道登录回调之后，再登录聚合接口，成功再回调给研发
            [QLApiGame loginXYWithSucc:^(NSDictionary * _Nonnull res) {
                //聚合登录成功之后，通知研发获取获取登录账号信息
                
                [QLsdkLoginConfiger share].user_Token = [res objectForKey:@"token"];
                [QLsdkLoginConfiger share].username = [res objectForKey:@"username"];
                NSMutableDictionary *SDKresultDic = [NSMutableDictionary new];
                [SDKresultDic setSafeValue:res[@"token"] forKey:@"token"];
                [SDKresultDic setSafeValue:res[@"username"] forKey:@"username"];
                [SDKresultDic setSafeValue:res[@"logintime"] forKey:@"logintime"];
                [SDKresultDic setSafeValue:res[@"sign"] forKey:@"sign"];
                [QLEventsListener callBackToGameWithNotiName:QLLoginNotification info:[QLEventsListener callBackParamsWithMsg:@"登录成功" code:@"1" data:SDKresultDic]];
            } failure:^(NSString * _Nonnull errMsg) {
                //聚合登录失败
                [QLEventsListener callBackToGameWithNotiName:QLLoginNotification info:[QLEventsListener callBackParamsWithMsg:@"登录失败" code:@"0" data:nil]];
            }];
        };
        
        [YiYouSDK_Kit sharedInstance].AYPaySuccessBack = ^(NSString *orderid){
            NSLog(@"下单成功返回订单号=======：%@",orderid);
            [QLEventsListener postMeshCheck:[NSString stringWithFormat:@"渠道支付成功返回的订单Id-%@--4",orderid]];
            //渠道支付成或者失败后，再回调
            [QLEventsListener callBackToGameWithNotiName:QLOrderNotification info:[QLEventsListener callBackParamsWithMsg:@"支付成功" code:@"1" data:nil]];
            
        };
        
        [YiYouSDK_Kit sharedInstance].AYExitAccount = ^(NSString *currentUserName) {
            NSLog(@"退出账号===%@",currentUserName);
            //TODO: 聚合SDK注销通知
            [QLEventsListener callBackToGameWithNotiName:QLLogoutNotification info:[QLEventsListener callBackParamsWithMsg:@"退出成功" code:@"1" data:nil]];
        };
        
        [YiYouSDK_Kit sharedInstance].AYUpdatesdkview = ^(NSString *updatestr) {
            NSLog(@"sdk更新  1：更新  其他：不更新");
        };

        [YiYouSDK_Kit sharedInstance].XKRealNameBack = ^(NSDictionary *data) {
            NSLog(@"实名认证获取成功");
        };
        
        //回调给研发
        
        [QLEventsListener callBackToGameWithNotiName:QLInitNotification info:[QLEventsListener callBackParamsWithMsg:@"激活成功" code:@"1" data:nil]];
        
        [QLEventsListener callBackToGameWithNotiName:QLSwitchAccountNotification info:[QLEventsListener callBackParamsWithMsg:@"切换账号" code:@"1" data:nil]];
        
    }
    
}


- (void)loginSDK {
    BOOL isshowed = [[NSUserDefaults standardUserDefaults] boolForKey:@"show"];
    isshowed = YES;//先yes
    if (!isshowed) {
        [self.pView show];
    }else{
        [self loginShowView];
    }

}



# pragma  mark  获取实名认证信息
- (NSDictionary *) GetVerifyInfo{
    
    return [[NSDictionary alloc] init];
    
}


# pragma  mark 显示渠道登录SDK
- (void) loginShowView{
    
    [QLEventsListener postMeshCheck:@"聚合SDK登录"];
    
    //TODO: 渠道SDK登录接口
    //显示登录页面
    [[YiYouSDK_Kit sharedInstance] addLogin:YES];
    
}

# pragma  mark 退出游戏
- (void)logoutSDK {
    //TODO: 渠道SDK注销接口
    
    [QLEventsListener postMeshCheck:@"聚合SDK退出"];
    [[YiYouSDK_Kit sharedInstance] cancelAccount];
    

    
}

- (void)ShowOrHideFloatView:(BOOL)status{
    
    [QLEventsListener postMeshCheck:@"聚合SDK显示悬浮窗"];
}


# pragma  mark  上传角色信息
- (void)sendRoleDataWithServerId:(NSString *)serverId serverName:(NSString *)serverName roleId:(NSString *)roleId roleLevel:(NSString *)roleLevel roleName:(NSString *)roleName roleType:(QLUserRoleType)roleType roleBalance:(NSString *)balance rolePower:(NSString *)power roleViplevel:(NSString *)vipLevel partName:(NSString *)partyName creatTime:(NSString *)time{
    
    [QLEventsListener postMeshCheck:@"聚合SDK选服"];
    [QLsdkRoleConfiter share].sId = serverId;
    [QLsdkRoleConfiter share].sName = serverName;
    [QLsdkRoleConfiter share].roleId =roleId;
    [QLsdkRoleConfiter share].roleName = roleName;
    [QLsdkRoleConfiter share].roleLevel = roleLevel;
    [QLsdkRoleConfiter share].balance =balance;
    [QLsdkRoleConfiter share].power = power;
    [QLsdkRoleConfiter share].creatTime = time;
    [QLsdkRoleConfiter share].vipLevel = vipLevel;
    [QLsdkRoleConfiter share].partyname = partyName;
    [QLsdkRoleConfiter share].roleType = roleType;
    
    //TODO: 渠道SDK选服接口
    
    //创建角色
    [[YiYouSDK_Kit sharedInstance] createRoleServerid:serverId//服务器ID (必须)
                                        serverName:serverName//服务器名 (必须)
                                          roleName:roleName//角色名 (必须)
                                            roleId:roleId//角色id  (必须)
                                        createRole:@"1"//是否创建新角色 (必须)1-是 0-否
                                       roleBalance:@"0"//游戏余额 (必须)
                                          vipLevel:vipLevel//VIP等级 (必须)
                                         roleLevel:roleLevel //角色等级 (必须)
                                         partyName:partyName////公会名称 (必须)
                                     create_role_time:[QlDeviceUtils getNowTimeTimestamp2]];//创角时间
    
    
    //TODO:聚合SDK接口
    [QLApiGame selectRoleWithServerId:^(NSDictionary * _Nonnull res) {
        
        [QLEventsListener callBackToGameWithNotiName:QLSendRoleDataNotification info:[QLEventsListener callBackParamsWithMsg:@"选服成功" code:@"1" data:@{@"type": @([QLsdkRoleConfiter share].roleType)}]];
        
    } failure:^(NSString * _Nonnull errMsg) {
        [QLEventsListener callBackToGameWithNotiName:QLSendRoleDataNotification info:[QLEventsListener callBackParamsWithMsg:@"选服失败" code:@"0" data:@{@"type": @([QLsdkRoleConfiter share].roleType)}]];
    }];
    
}

# pragma  mark 下单
- (void)orderWithProductId:(NSString *)productId goodsName:(NSString *)productName goodsDec:(NSString *)productDec price:(NSString *)price serverId:(NSString *)serverId serverName:(NSString *)serverName roleId:(NSString *)roleId roleLevel:(NSString *)roleLevel roleName:(NSString *)roleName gameOther:(NSString *)gameOther{
    
    [QLEventsListener postMeshCheck:@"调用聚合SDK下订单--1"];
    [QLsdkPayConfiter share].price = price;
    [QLsdkPayConfiter share].productId = productId;
    [QLsdkPayConfiter share].productName = productName;
    [QLsdkPayConfiter share].gameOther = gameOther;
    [QLsdkPayConfiter share].productDec = productDec;
    [QLsdkPayConfiter share].roleId = roleId;
    [QLsdkPayConfiter share].roleName = roleName;
    [QLsdkPayConfiter share].serverId = serverId;
    [QLsdkPayConfiter share].serverName = serverName;
    
    //在后台创建订单，成功之后，再掉用渠道SDK的支付接口
    [QLApiGame creatPreOrder:^(NSDictionary * _Nonnull res) {
        [QLEventsListener postMeshCheck:@"聚合SDK下订单返回成功--2"];
        //TODO: 渠道SDK支付接口
        [QLEventsListener postMeshCheck:@"调用渠道下订单接口--3"];
        [[YiYouSDK_Kit sharedInstance]showPayViewAmount:price//订单金额
                                              productID:productId//商品id
                                         productName:productName//商品名称
                                            productDesc:productDec
                                            serverID:serverId//区服ID
                                          serverName:serverName//区服名称
                                              roleID:roleId //角色ID
                                            roleName:roleName//roleName
                                           roleLevel:roleLevel//角色等级
                                              attach:gameOther//CP扩展参数
                                       andcompletion:^(NSString *resultData) {
                                       }];
    
    } failure:^(NSString * _Nonnull errMsg) {
        [QLEventsListener postMeshCheck:@"聚合SDK下订单返回失败--2"];
        [QLEventsListener callBackToGameWithNotiName:QLOrderNotification info:[QLEventsListener callBackParamsWithMsg:@"支付失败" code:@"0" data:nil]];
        
    }];
    
    
}


- (void)selectIndexDic:(NSInteger)tag{
    if (tag != 30) {
        exit(0);
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"show"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loginShowView];
    }
}



// H5游戏
//获取webview
- (WKWebView *)getJSWebView{
    
    return  [[QLJHSDKWebJs sharedSingleton] getJSWebView];
}

//加载url
- (void)loadRequest:(WKWebView *)webView{
    
    [[QLJHSDKWebJs sharedSingleton] loadRequest:webView];
    
}

//移除js方法
- (void)removeScriptMessage:(WKWebView *)webView{
    
    [[QLJHSDKWebJs sharedSingleton] removeScriptMessage:webView];
    
}

#pragma mark - 周期函

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [QLEventsListener postMeshCheck:@"聚合SDK-didFinishLaunchingWithOptions"];
    // 研发是否调用这个系统函数
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"didFinishLaunchingWithOptions"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [YiYouSDK_Kit application:application didFinishLaunchingWithOptions:launchOptions];
    return  YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options{
    
    return  YES;
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    return  YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    
    return  YES;
}


- (void)applicationWillResignActive:(UIApplication *)application{
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application{
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application{
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application{
    
}


- (void)applicationWillTerminate:(UIApplication *)application{
    
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
}

#pragma mark - private
- (UIViewController *)getCurrentRootViewController {
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


@end

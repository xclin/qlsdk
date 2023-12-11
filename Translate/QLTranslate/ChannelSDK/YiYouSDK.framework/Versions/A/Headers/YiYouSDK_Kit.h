//
//  YLPlatformSDK_Kit.h
//  YiYouSDK
//
//  Created by ylwl on 2017/10/24.
//  Copyright © 2017年 com.youguu.h5gameCenter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "AppCommon.h"

@interface YiYouSDK_Kit : NSObject

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
+ (void)applicationWillEnterForeground:(UIApplication *)application;
+ (void)applicationWillResignActive:(UIApplication *)application;
+ (void)applicationDidEnterBackground:(UIApplication *)application ;
+ (void)applicationDidBecomeActive:(UIApplication *)application ;
+ (void)applicationWillTerminate:(UIApplication *)application ;
+ (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;

+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options;
+ (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
+ (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void(^)(NSArray * restorableObjects))restorationHandler;
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+ (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window;

/**
 * @brief loginState=0 未登录  1已登录 2注销
 */
@property (nonatomic,assign) unsigned int myLoginState;

@property (nonatomic,assign) unsigned int firstState;

/**
 * @brief 登入成功 回调
 */
@property (nonatomic, copy) void (^AYLoginSuccessBack)(NSString * paramToken,NSString *userName,NSString *time,NSString *sign);
/**
 * @brief 退出账号
 */
@property (nonatomic, copy) void (^AYExitAccount)(NSString * currentUserName);
/**
 * @brief 充值成功回调(私有的)苹果支付的回调
 */
//@property (nonatomic, copy) void (^AYSuccessPayBack)(NSString * resultData);
/**
 @brief 支付回调
 @param data SDK返回的订单号
 */
@property (nonatomic, copy) void (^AYPaySuccessBack)(NSString * orderid);


@property (nonatomic, copy) void (^AYPayErrorBack)(NSString * msg);



/// 实名认证获取回调
@property (nonatomic, copy) void (^XKRealNameBack)(NSDictionary * data);

/// 聚合sdk登录页面更新
@property (nonatomic, copy) void (^AYUpdatesdkview)(NSString * updatestr);

/**
 *  获取账户管理的单例
 *
 *  @return 返回账户管理的单例
 */
+ (instancetype)sharedInstance;

/**
 *  @brief 初始化
 *  @param appId  游戏pid
 *  @param appKey 游戏appKey
 *  @param gameID 游戏ID
 */

//此接口已废弃 appId appKey gameID 只要在 YiYouSDKYLinfo.plist配置即可
//-(void)YiYouSdkInitAppId:(NSString *)appId
//               appKey:(NSString *)appKey
//               gameID:(NSString *)gameID;


/**
 * @showLogin   弹出登录页面
 * @animated  是否动画
 */
- (void)addLogin:(BOOL)animated;

/**
 @brief 创建角色 - 支付成或者失败无需回调，服务器直接对接
 @param serverid   服务器ID (必须)
 @param servername 服务器名 (必须)
 @param rolename 角色名 (必须)
 @param roleid    角色id  (必须)
 @param create_role    是否创建新角色 (必须)1-是 0-否
 @param rolebalance     游戏余额 (必须)
 @param viplevel    VIP等级 (必须)
 @param rolelevel   角色等级 (必须)
 @param partyname      公会名称 (必须)
 @param create_role_time      创角时间 (必须)
 */
- (void)createRoleServerid:(NSString *)serverid
                serverName:(NSString *)servername
                  roleName:(NSString *)rolename
                    roleId:(NSString *)roleid
                createRole:(NSString *)create_role        //是否创建角色 1 - 是 0 - 否
               roleBalance:(NSString *)rolebalance
                  vipLevel:(NSString *)viplevel
                 roleLevel:(NSString *)rolelevel
                 partyName:(NSString *)partyname
          create_role_time:(NSString *)create_role_time;
/**
 @brief 加载支付页面 - 支付成或者失败无需回调，服务器直接对接
 
 @param amount      订单金额，单位RMB元，由调用方传入 (必须)
 @param productName 订单标题，由调用方传入 (必须)
 @param productDesc 订单描述，由调用方传入
 @param productId   商品id 必填
 @param serverID    服务器ID (必须)
 @param roleID      角色ID (必须)
 @param roleName    角色名称 (必须)
 @param roleLevel   角色等级 (必须)
 @param attach      CP扩展参数 (必须)
 */
- (void)showPayViewAmount:(NSString*)amount
                productID:(NSString*)productId
              productName:(NSString*)productName
              productDesc:(NSString*)productDesc
                 serverID:(NSString*)serverID
                 serverName:(NSString*)serverName
                   roleID:(NSString*)roleID
                 roleName:(NSString*)roleName
                roleLevel:(NSString*)roleLevel
                   attach:(NSString*)attach
            andcompletion:(void (^)(NSString * resultData))success;

/// 获取实名信息

-(void)getVerifyInfo;

/**
  * @brief     注销
 */
- (void)cancelAccount;

/**
 * @brief     获取当前用户名 （可以做为唯一标识）
 * 废弃
 */
- (NSString *)currentUserName;

/**
 * @brief     显示悬浮球
 */
-(void)YPShowBall;
/**
 * @brief     隐藏悬浮球
 */
-(void)YPHidenBall;
/**
 * @brief     内部调试打印输出
 */
+(void)postMeshCheck:(NSString*)meshName;



@end



#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

#define  GLGamaShare [QLGameManager shared]
/// 角色操作事件类型
typedef NS_ENUM(NSInteger, QLUserRoleType)
{
    QL_TYPE_LEVEL_UP = 1,   //角色升级
    QL_TYPE_CREAT_Role = 2,//创角色 首次进入游戏选服创角色
    QL_TYPE_SELECT_Enter = 3//进入游戏
   
};


@interface QLGameManager : NSObject
+ (instancetype)shared;


/**

 *  用户唯一标识
 */
@property (nonatomic,copy) NSString * uid;

/**
 获取用户账号 (需要登录)
 */
@property (nonatomic,copy) NSString * accountName;


/**
 获取用户token (需要登录)
 */
@property (nonatomic,copy) NSString * token;


/// 激活SDK
- (void) initSDK;

/// 登录SDK
- (void) loginSDK;

/// 注销SDK
- (void) logoutSDK;

/// 选服
/// @param serverId 服务器Id
/// @param serverName 服务器名称
/// @param roleId 角色Id
/// @param roleLevel 角色等级
/// @param roleName 角色名称
/// @param roleType 角色操作类型
/// @param balance 游戏币数量
/// @param power 战斗力
/// @param viplevel vip VIP登记
/// @param partyName   公会名
/// @param time  角色创建时间
- (void)sendRoleDataWithServerId:(NSString *)serverId serverName:(NSString *)serverName roleId:(NSString *)roleId roleLevel:(NSString *)roleLevel roleName:(NSString *)roleName roleType:(QLUserRoleType)roleType roleBalance:(NSString *)balance rolePower:(NSString *)power roleViplevel:(NSString *)viplevel partName:(NSString *)partyName creatTime:(NSString *)time;

/// 下单
/// @param productId 商品id
/// @param productName 商品名称
/// @param productDec 商品描述
/// @param price 价格
/// @param serverId 服务器id
/// @param serverName 服务器名称
/// @param roleId 角色id
/// @param roleLevel 角色等级
/// @param roleName 角色名称
/// @param gameOther 透传参数
- (void)orderWithProductId:(NSString *)productId goodsName:(NSString *)productName goodsDec:(NSString *)productDec price:(NSString *)price serverId:(NSString *)serverId serverName:(NSString *)serverName roleId:(NSString *)roleId roleLevel:(NSString *)roleLevel roleName:(NSString *)roleName gameOther:(NSString *)gameOther;


#pragma mark 非必须实现扩展接口

/// 获取实名认证信息
///
- (NSDictionary *) GetVerifyInfo;


/**
 设置悬浮窗的显示与隐藏
 @param status 当status = YES时，显示悬浮窗；
 *             当status = NO时，不显示悬浮窗；
 */
- (void)ShowOrHideFloatView:(BOOL)status;



// H5游戏
//获取webview
- (WKWebView *)getJSWebView;

//加载url
- (void)loadRequest:(WKWebView *)webView;

//移除js方法
- (void)removeScriptMessage:(WKWebView *)webView;



#pragma mark - 生命周期函数 必须调用。 参考demo

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options;


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;


- (void)applicationWillResignActive:(UIApplication *)application;


- (void)applicationDidEnterBackground:(UIApplication *)application;


- (void)applicationWillEnterForeground:(UIApplication *)application;


- (void)applicationDidBecomeActive:(UIApplication *)application;


- (void)applicationWillTerminate:(UIApplication *)application;

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window;

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END

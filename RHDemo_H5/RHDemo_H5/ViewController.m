
#import "ViewController.h"
#import <QLTranslate/QLTranslate.h>
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化成功回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(QLinitCallBack:) name:QLInitNotification object:nil];
    //用户登录回调
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(QLloginCallBack:) name:QLLoginNotification object:nil];
    //用户注销回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QLlogoutCallBack:) name:QLLogoutNotification object:nil];
    //选服操作回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QLselectRoleCallBack:) name:QLSendRoleDataNotification object:nil];
    //内购操作回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QLorderCallBack:) name:QLOrderNotification object:nil];
    //切换账号
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QLSwitchAccounCallBack:) name:QLSwitchAccountNotification object:nil];
    [[QLGameManager shared] initSDK];
}

- (IBAction)loginGameAction:(id)sender {
    [[QLGameManager shared] loginSDK];
}

- (IBAction)logoutGameAction:(id)sender {
    
    [[QLGameManager shared] logoutSDK];
}

- (IBAction)selectRoleAction:(id)sender {
   
    [GLGamaShare sendRoleDataWithServerId:@"001" serverName:@"测试服" roleId:@"01" roleLevel:@"0" roleName:@"测试角色" roleType:QL_TYPE_CREAT_Role roleBalance:@"0" rolePower:@"0" roleViplevel:@"0" partName:@"无" creatTime:@""];
}

- (IBAction)buyAction:(id)sender {

    [GLGamaShare orderWithProductId:@"com.produce.6" goodsName:@"进步" goodsDec:@"60金币" price:@"6" serverId:@"001" serverName:@"测试服" roleId:@"01" roleLevel:@"0" roleName:@"测试角色" gameOther:[self getNowTimeTimestamp2]];
}


#pragma mark - NSNotification Action
- (void)QLinitCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    
    NSLog(@"initCallBack--code:%@,msg:%@", code, msg);
    if ([code intValue] == 1) {//成功

    } else {//失败
        
    }
}

- (void)QLSwitchAccounCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    
    NSLog(@"initCallBack--code:%@,msg:%@", code, msg);
    if ([code intValue] == 1) {//切换账号

    } else {//切换失败
        
    }
    
}


- (void)QLloginCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    if ([code intValue] ==1) {//登录成功
        NSString *sign = info[@"data"][@"sign"];
        NSString *token = info[@"data"][@"token"];
        NSString *username = info[@"data"][@"username"];
        NSLog(@"loginCallBack--code:%@, msg:%@, sign:%@, token:%@, accountName:%@", code, msg, sign, token, username);
    } else {
        NSLog(@"loginCallBack--code:%@,msg:%@", code, msg);
    }
}

- (void)QLlogoutCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    NSLog(@"logoutCallBack");
    if ([code intValue] == 1) {//注销成功
        
    } else {//注销失败
        
    }
}

- (void)QLselectRoleCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    if ([code intValue] == 1) {//角色操作成功
        NSDictionary *data = info[@"data"];
    } else {//角色操作失败
        
    }
    NSLog(@"selectRoleCallBack--code:%@,msg:%@", code, msg);
}

- (void)QLorderCallBack:(NSNotification *)notification {
    NSDictionary *info = notification.userInfo;
    NSString *code = info[@"code"];
    NSString *msg = info[@"msg"];
    if ([code intValue] == 1) {//支付成功
           
    } else {//支付失败
           
    }
    NSLog(@"orderCallBack--code:%@,msg:%@", code, msg);
}



- (NSString *)getNowTimeTimestamp2 {
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}


@end

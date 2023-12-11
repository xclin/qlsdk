#import "QLApiGame.h"
#import "QlRequestUtils.h"
#import "QLsdkInitConfiger.h"
#import "QlDeviceUtils.h"
#import "QLUrlList.h"
#import "QLsdkLoginConfiger.h"
#import "NSMutableDictionary+QLValueNonnull.h"
#import "QLsdkRoleConfiter.h"
#import "QLsdkPayConfiter.h"

@implementation QLApiGame

+ (void)initXYWithSucc:(SuccBlock)succ failure:(FailureBlock)failure {//NModel_Base NModel_Init
    NSMutableDictionary * postParams = [self returnPublicParams ];

    //需要返回激活的参数
    NSString *url = [NSString stringWithFormat:@"%@%@", @"", qlUriInit];
    [QlRequestUtils postWithUrl:url parms:postParams timeout:10 succeed:^(NSDictionary * _Nonnull responseObject) {

        succ(responseObject);
    } failure:^(NSString * _Nonnull errMsg) {
        failure(errMsg);
    }];
}


#pragma  mark 登录
+ (void)loginXYWithSucc:(SuccBlock)succ failure:(FailureBlock)failure { // NModel_Base NModel_Login
    NSMutableDictionary *postParams = [self returnPublicParams];
    [postParams setSafeValue:[QLsdkLoginConfiger share].channel_username forKey:@"username"];
    [postParams setSafeValue:[QLsdkLoginConfiger share].channel_user_Token forKey:@"channelToken"];
    [postParams setSafeValue:@3 forKey:@"device"];
    [postParams setSafeValue:[QlDeviceUtils stringWithMD5Dict:postParams]  forKey:@"sign"];

    NSString *url = [NSString stringWithFormat:@"%@%@%@",qlProtocol,qlDomain, qlUrlLogin];
    [QlRequestUtils postWithUrl:url parms:postParams timeout:10 succeed:^(NSDictionary * _Nonnull responseObject) {
        int code = [responseObject[@"code"] intValue];
        if (code == 1) {
            succ(responseObject[@"data"]);
        }else{
            failure(responseObject[@"msg"]);
        }
    } failure:^(NSString * _Nonnull errMsg) {
        failure(errMsg);
    }];
}


#pragma  mark 选服
+ (void)selectRoleWithServerId:(SuccBlock)succ failure:(FailureBlock)failure{
    NSMutableDictionary *postParams = [self returnPublicParams];
    [postParams setSafeValue:[QLsdkRoleConfiter share].sName forKey:@"servername"];
    [postParams setSafeValue:[QLsdkRoleConfiter share].sId forKey:@"serverid"];
    [postParams setSafeValue:[QLsdkRoleConfiter share].roleId forKey:@"roleid"];
    [postParams setSafeValue:[QLsdkRoleConfiter share].roleName forKey:@"rolename"];
    [postParams setSafeValue:[QLsdkRoleConfiter share].vipLevel forKey:@"viplevel"];
    [postParams setSafeValue:[QLsdkRoleConfiter share].roleLevel forKey:@"rolelevel"];
    [postParams setSafeValue:[QLsdkRoleConfiter share].balance forKey:@"rolebalance"];
    [postParams setSafeValue:[QLsdkRoleConfiter share].partyname forKey:@"partyname"];
    [postParams setSafeValue:[QLsdkLoginConfiger share].user_Token forKey:@"token"];
    [postParams setSafeValue:[QlDeviceUtils stringWithMD5Dict:postParams]  forKey:@"sign"];


    NSString *url = [NSString stringWithFormat:@"%@%@%@",qlProtocol,qlDomain, qlUrlSlectRole];
    [QlRequestUtils postWithUrl:url parms:postParams timeout:10 succeed:^(NSDictionary * _Nonnull responseObject) {
        succ(responseObject);
        NSLog(@"responseObject--%@",responseObject);
    } failure:^(NSString * _Nonnull errMsg) {
        failure(errMsg);
        NSLog(@"errMsg--%@",errMsg);
    }];
}


#pragma  mark 创建订单
+ (void)creatPreOrder:(SuccBlock)succ failure:(FailureBlock)failure{
    NSMutableDictionary * postParams =[self returnPublicParams ];
    [postParams  setSafeValue:[QLsdkPayConfiter share].price forKey:@"amount"];
    [postParams  setSafeValue:[QLsdkPayConfiter share].productId forKey:@"productID"];
    [postParams  setSafeValue:[QLsdkPayConfiter share].productName forKey:@"productname"];
    [postParams  setSafeValue:[QLsdkPayConfiter share].serverId forKey:@"serverid"];
    [postParams  setSafeValue:[QLsdkPayConfiter share].serverName forKey:@"serverName"];
    [postParams  setSafeValue:[QLsdkPayConfiter share].roleId forKey:@"roleid"];
    [postParams  setSafeValue:[QLsdkPayConfiter share].roleName forKey:@"rolename"];
    [postParams  setSafeValue:[QLsdkPayConfiter share].productDec forKey:@"productDesc"];
    [postParams  setSafeValue:[QLsdkPayConfiter share].gameOther forKey:@"attach"];
    [postParams  setSafeValue:[QLsdkLoginConfiger share].user_Token forKey:@"token"];
    [postParams  setSafeValue:[QLsdkRoleConfiter share].roleLevel forKey:@"rolelevel"];
    [postParams  setValue:[QlDeviceUtils stringWithMD5Dict:postParams] forKey:@"sign"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@", qlProtocol,qlDomain, qlurlCreatorder];
    [QlRequestUtils postWithUrl:url parms:postParams timeout:10 succeed:^(NSDictionary * _Nonnull responseObject) {
        succ(responseObject);
        NSLog(@"creatPreOrder--responseObject--%@",responseObject);
    } failure:^(NSString * _Nonnull errMsg) {
        failure(errMsg);
        NSLog(@"errMsg--%@",errMsg);
    }];
    
}



# pragma mark 公共请求参数
+ (NSMutableDictionary *)returnPublicParams{
    NSMutableDictionary *postParams = [NSMutableDictionary new];
    [postParams  setSafeValue:[QLsdkInitConfiger share].appid forKey:@"appid"];
    [postParams setSafeValue:[QLsdkInitConfiger share].gameid forKey:@"gameid"];
    [postParams  setSafeValue:[QLsdkInitConfiger share].equipmentIDFA forKey:@"imeil"];
    [postParams setSafeValue:[QLsdkInitConfiger share].channel_mark forKey:@"channel_mark"];
    
   
    return postParams;
}

@end

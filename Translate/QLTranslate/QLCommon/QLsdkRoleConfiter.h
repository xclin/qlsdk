//
//  sdkRoleConfiter.h
//  Translate
//
//  Created by xiaocong lin on 2020/8/3.
//  Copyright © 2020 wuwh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLGameManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface QLsdkRoleConfiter : NSObject

/// 服务器id
@property (nonatomic, copy) NSString * sId;
/// 服务器名称
@property (nonatomic, copy) NSString * sName;
/// 角色id
@property (nonatomic, copy) NSString * roleId;
/// 角色等级
@property (nonatomic, copy) NSString * roleLevel;
/// 角色名称
@property (nonatomic, copy) NSString * roleName;
/// 余额
@property (nonatomic, copy) NSString * balance;
/// 角色战力
@property (nonatomic, copy) NSString * power;
/// 角色创建时间
@property (nonatomic, copy) NSString * creatTime;
/// 角色VIP等级
@property (nonatomic, copy) NSString * vipLevel;
/// 角色公会名称
@property (nonatomic, copy) NSString * partyname;
/// 事件类型 2：创建角色 3：进入游戏 4、角色升级
@property (nonatomic, assign)  QLUserRoleType roleType;

+ (instancetype)share;
@end

NS_ASSUME_NONNULL_END

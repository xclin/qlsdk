//
//  sdkPayConfiter.h
//  Translate
//
//  Created by 凡跃 on 2021/8/10.
//  Copyright © 2021 wuwh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface sdkPayConfiter : NSObject
/// cp订单
@property (nonatomic, copy) NSString * transactionId;
/// 商品id
@property (nonatomic, copy) NSString * productId;
/// 商品名
@property (nonatomic, copy) NSString * productName;
/// 商品描述
@property (nonatomic, copy) NSString * productDec;
/// 价格
@property (nonatomic, copy) NSString * price;
/// 服务id
@property (nonatomic, copy) NSString * serverId;
/// 服务名
@property (nonatomic, copy) NSString * serverName;
/// 角色id
@property (nonatomic, copy) NSString * roleId;
/// 角色名
@property (nonatomic, copy) NSString * roleName;
/// 拓展参数
@property (nonatomic, copy) NSString * gameOther;

+ (instancetype)share;
@end



NS_ASSUME_NONNULL_END

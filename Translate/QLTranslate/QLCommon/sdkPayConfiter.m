//
//  sdkPayConfiter.m
//  Translate
//
//  Created by 凡跃 on 2021/8/10.
//  Copyright © 2021 wuwh. All rights reserved.
//

#import "sdkPayConfiter.h"


static sdkPayConfiter * shareConfigerManager = nil;

@implementation sdkPayConfiter
+ (instancetype)share{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        if (shareConfigerManager == nil) {
            shareConfigerManager = [[self alloc]init];
        }
    });
    return shareConfigerManager;
}





- (NSString *)transactionId{
    
    if (!_transactionId) {
       return  @"";
    }
    return _transactionId;;
}

- (NSString *)productId{
    
    if (!_productId) {
       return  @"";
    }
    
    return _productId;;
}

-(NSString *)productName{
    if (!_productName) {
       return  @"";
    }
    
 return _productName;
}

- (NSString *)roleName{
    
    if (!_roleName) {
       return  @"";
    }
    
    return _roleName;;
}

- (NSString *)productDec{
    if (!_productDec) {
       return  @"";
    }
    
    return _productDec;
}

-(NSString *)gameOther{
    
    if (!_gameOther) {
       return  @"";
    }
    
    return _gameOther;
}

- (NSString *)roleId{
    if (!_roleId) {
       return  @"";
    }
    
    return _roleId;
}

- (NSString *)serverName{
    
    if (!_serverName) {
       return  @"";
    }
    return _serverName;
    
}


- (NSString *)serverId{
    
    if (!_serverId) {
       return  @"";
    }
    return _serverId;
    
}

- (NSString *)price{
    
    if (!_price) {
       return  @"";
    }
    return _price;
    
}

@end

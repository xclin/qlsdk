
#import <Foundation/Foundation.h>
#import "QLGameManager.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^FailureBlock)(NSString *errMsg);
typedef void(^SuccBlock)(NSDictionary *res);

@interface QLApiGame : NSObject

/// XY-激活SDK
/// @param succ 成功回调
/// @param failure 失败错误信息
+ (void)initXYWithSucc:(SuccBlock)succ failure:(FailureBlock)failure;


/// XY-登录
/// @param succ 成功回调
/// @param failure 失败错误信息
+ (void)loginXYWithSucc:(SuccBlock)succ failure:(FailureBlock)failure;


/// XY-选服
/// @param succ 成功回调
/// @param failure 失败错误信息
+ (void)selectRoleWithServerId:(SuccBlock)succ failure:(FailureBlock)failure;



/// XY-预下单
/// @param succ 成功回调
/// @param failure 失败错误信息
+ (void)creatPreOrder:(SuccBlock)succ failure:(FailureBlock)failure;
@end

NS_ASSUME_NONNULL_END

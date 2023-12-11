

#import <Foundation/Foundation.h>


@interface QLsdkLoginConfiger : NSObject
@property (nonatomic, copy) NSString * channel_result;//渠道返回的数据，如：{"uid":"62543","token":"92434a9695d2c6ff4e88872590c20587","account":"yuyuyu"} 不同渠道，返回不一样的数据
@property (nonatomic, copy) NSString * s_uid;
@property (nonatomic, copy) NSString * user_Token;
@property (nonatomic, copy) NSString * username;

@property (nonatomic, copy) NSString * channel_user_Token;
@property (nonatomic, copy) NSString * channel_username;

+ (instancetype)share;
@end




#import <Foundation/Foundation.h>

@interface QLsdkInitConfiger : NSObject

@property(nonatomic, copy) NSString* appid;
@property(nonatomic, copy) NSString* appKey;
@property(nonatomic, copy) NSString* gameid;
@property(nonatomic, copy) NSString* channel_mark;//渠道名
@property (nonatomic,copy) NSString *equipmentIDFA;        /**<手机广告标识符**/
@property(nonatomic,assign) BOOL showBug;              //log 日志 开关
+ (instancetype)share;

@end





#import <Foundation/Foundation.h>


@interface QLEventsListener : NSObject
+ (instancetype)shared;

- (void)startListen;

+ (void)callBackToGameWithNotiName:(NSString *)notiName info:(NSDictionary *)info;


+ (NSMutableDictionary *)callBackParamsWithMsg:(NSString *)msg code:(NSString *)code data:(NSDictionary *)data;


/// 上传日志
/// - Parameter meshName: 信息
+(void)postMeshCheck:(NSString*)meshName;

@end



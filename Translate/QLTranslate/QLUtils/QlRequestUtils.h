

#import <Foundation/Foundation.h>

@interface QlRequestUtils : NSObject



+ (void)getWithUrl:(NSString * _Nullable)url parms:(NSMutableDictionary * _Nullable)parms timeout:(float)timeout succeed:(void (^ _Nullable)(NSDictionary * _Nonnull))completionBlock failure:(void (^ _Nullable)(NSString * _Nonnull))failureBlock;

+ (void)postWithUrl:(NSString *_Nonnull)url parms:(NSMutableDictionary *_Nullable)parms timeout:(float)timeout succeed:(void (^_Nullable)(NSDictionary * _Nonnull responseObject))completionBlock failure:(void (^_Nullable)(NSString * _Nonnull errMsg))failureBlock;

@end


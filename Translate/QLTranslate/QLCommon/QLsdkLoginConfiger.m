
#import "QLsdkLoginConfiger.h"

static QLsdkLoginConfiger * shareConfigerManager = nil;

@implementation QLsdkLoginConfiger
+ (instancetype)share{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        if (shareConfigerManager == nil) {
            shareConfigerManager = [[self alloc]init];
        }
    });
    return shareConfigerManager;
}

-(NSString *)channel_result{
    if (!_channel_result) {
        
        _channel_result = @"";
    }
    return _channel_result;;
}
@end


#import "QLsdkPayConfiter.h"


static QLsdkPayConfiter * shareConfigerManager = nil;

@implementation QLsdkPayConfiter
+ (instancetype)share{
    static dispatch_once_t once;
    dispatch_once(&once,^{
        if (shareConfigerManager == nil) {
            shareConfigerManager = [[self alloc]init];
        }
    });
    return shareConfigerManager;
}

@end

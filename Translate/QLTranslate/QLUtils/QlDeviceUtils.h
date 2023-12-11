
#import <Foundation/Foundation.h>
#import "QLsdkInitConfiger.h"


@interface QlDeviceUtils : NSObject

+ (NSString *)deviceIdfv;
+ (NSString *)ipAddress;
+ (NSString *)idfa;
+ (NSString *)jsondata;
+ (NSString *)devicetoken;
+ (NSDictionary*)jsonModel:(NSMutableDictionary *) jsonModel;
+ (NSString *)compareWithNSDictionary:(NSDictionary*)dic;
+ (NSString *)cpsid;
+ (NSString *)aid;
+(NSString *)stringWithMD5Dict:(NSDictionary *)dict;
+ (NSString *)getNowTimeTimestamp2;
@end


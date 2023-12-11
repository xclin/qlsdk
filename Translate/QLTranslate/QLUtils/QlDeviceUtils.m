
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <sys/sysctl.h>
#import "QlDeviceUtils.h"
#import <AdSupport/AdSupport.h>
#import "sys/utsname.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "QlEncryptUtils.h"
#import "QlKeyChainUtils.h"
#import "QLsdkInitConfiger.h"
#define setIDFV(IDFV) [[NSUserDefaults standardUserDefaults] setObject:(IDFV) forKey:@"IDFV"];[[NSUserDefaults standardUserDefaults] synchronize];
#define getIDFV [[NSUserDefaults standardUserDefaults] objectForKey:@"IDFV"]
#define SDKIdentifier [NSString stringWithFormat:@"01_%@_%@_20200420_sdkxy",[[NSBundle mainBundle] bundleIdentifier],[QLsdkInitConfiger share].ver]

@implementation QlDeviceUtils

+ (NSString *)deviceIdfv {
    //如果空值，随机生成18位数
    if ([getIDFV length] == 0) {
        NSString *idfv = [self getRandomidfv:18];
        setIDFV(idfv);
    }
    return getIDFV;
    
}

+ (NSString *)ipAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
 
    success = getifaddrs(&interfaces);
    if (success == 0) {
 
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            if (temp_addr->ifa_addr->sa_family == AF_INET6) {
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
    
}

+ (NSString *)idfa {
    NSString *idfaStr = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfaStr;
}

+ (NSString *)jsondata {
    NSString * jsondataStr = [self deviceMsg]==nil?@"":[self deviceMsg];
    return jsondataStr;;
}


#pragma mark - private


#pragma mark 签名
+(NSString *)stringWithMD5Dict:(NSDictionary *)dict {
    NSArray *keys = [dict allKeys];
    NSArray *sorteArr = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return[obj1 compare:obj2 options:NSNumericSearch];//正序
    }];
    NSString *str = @"";
    for (id key in sorteArr) {
        id value = [dict objectForKey:key];
        NSString *thekey = [[NSString stringWithFormat:@"%@",key] lowercaseString];
        NSString *theValue = [[NSString stringWithFormat:@"%@",value] lowercaseString];
        str = [str stringByAppendingFormat:@"%@=%@",thekey,theValue];
    }
    str = [str stringByAppendingString:[QLsdkInitConfiger share].appKey];
    NSLog(@"str====%@",str);
    str = [str md5String];
    return str;
}



+ (NSString *)deviceMsg {
    if ([getIDFV length] == 0) {
        NSString *idfv = [self getRandomidfv:18];
        setIDFV(idfv);
    }
    NSString *network_name;
    if ([[self networkType] isEqualToString:@"WIFI"]){
        network_name = [self wifiName];
    }else{
        network_name = [self carrierName];
    }
    NSString *ip =  [self ipAddress]; //ip地址
    NSString *model = [self getDeviceName];//手机型号
    NSString *version = [QlDeviceUtils sysVersion]; //系统版本
    NSString *resolution = [NSString stringWithFormat:@"%.0f*%.0f",[self getWidth],[self getHeight]];
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:@{@"phone_ip":ip, @"phone_model":model, @"phone_version":version,@"phone_resolution":resolution,@"idfa":[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],@"idfv":getIDFV,@"network_type":[self networkType],@"network_name":network_name,@"progress":[NSProcessInfo processInfo].processName,@"behavior_id":@""} options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return myString;
}

/**
 *  获得设备名字
 *
 *  @return string
 */
+ (NSString *)getDeviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([deviceString isEqualToString:@"iPhone3,1"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,2"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone3,3"])
        return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])
        return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,1"])
        return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone5,2"])
        return @"iPhone 5 (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPhone5,3"])
        return @"iPhone 5c (GSM)";
    if ([deviceString isEqualToString:@"iPhone5,4"])
        return @"iPhone 5c (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPhone6,1"])
        return @"iPhone 5s (GSM)";
    if ([deviceString isEqualToString:@"iPhone6,2"])
        return @"iPhone 5s (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPhone7,1"])
        return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])
        return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])
        return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])
        return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,4"])
        return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceString isEqualToString:@"iPhone9,1"])
        return @"国行_日版_港行iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,2"])
        return @"港行_国行iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"])
        return @"美版_台版iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,4"])
        return @"美版_台版iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone10,1"])
        return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"])
        return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])
        return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,5"])
        return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])
        return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,6"])
        return @"iPhone X";
    
    if ([deviceString isEqualToString:@"iPhone11,2"])
        return @"iPhone XS";
    if ([deviceString isEqualToString:@"iPhone11,4"])
        return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,6"])
        return @"iPhone XS Max";
    if ([deviceString isEqualToString:@"iPhone11,8"])
        return @"iPhone XR";
    if ([deviceString isEqualToString:@"iPhone12,1"])
        return @"iPhone 11";
    if ([deviceString isEqualToString:@"iPhone12,3"])
        return @"iPhone 11 Pro";
    if ([deviceString isEqualToString:@"iPhone12,5"])
        return @"iPhone 11 Pro Max";
    
    
    if ([deviceString isEqualToString:@"iPod1,1"])
        return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])
        return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])
        return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])
        return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])
        return @"iPod Touch (5 Gen)";
    if ([deviceString isEqualToString:@"iPad1,1"])
        return @"iPad";
    if ([deviceString isEqualToString:@"iPad1,2"])
        return @"iPad 3G";
    if ([deviceString isEqualToString:@"iPad2,1"])
        return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])
        return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,3"])
        return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"iPad2,4"])
        return @"iPad 2";
    if ([deviceString isEqualToString:@"iPad2,5"])
        return @"iPad Mini (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,6"])
        return @"iPad Mini";
    if ([deviceString isEqualToString:@"iPad2,7"])
        return @"iPad Mini (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPad3,1"])
        return @"iPad 3 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,2"])
        return @"iPad 3 (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPad3,3"])
        return @"iPad 3";
    if ([deviceString isEqualToString:@"iPad3,4"])
        return @"iPad 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad3,5"])
        return @"iPad 4";
    if ([deviceString isEqualToString:@"iPad3,6"])
        return @"iPad 4 (GSM_CDMA)";
    if ([deviceString isEqualToString:@"iPad4,1"])
        return @"iPad Air (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,2"])
        return @"iPad Air (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,4"])
        return @"iPad Mini 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad4,5"])
        return @"iPad Mini 2 (Cellular)";
    if ([deviceString isEqualToString:@"iPad4,6"])
        return @"iPad Mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"])
        return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,8"])
        return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad4,9"])
        return @"iPad Mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"])
        return @"iPad Mini 4 (WiFi)";
    if ([deviceString isEqualToString:@"iPad5,2"])
        return @"iPad Mini 4 (LTE)";
    if ([deviceString isEqualToString:@"iPad5,3"])
        return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad5,4"])
        return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,3"])
        return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,4"])
        return @"iPad Pro 9.7";
    if ([deviceString isEqualToString:@"iPad6,7"])
        return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"iPad6,8"])
        return @"iPad Pro 12.9";
    if ([deviceString isEqualToString:@"i386"])
        return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])
        return @"Simulator";
    return deviceString;
}

/// 获取网络类型
+ (NSString *)networkType {
    NSString *strNetworkType = @"";
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_storage zeroAddress;
    
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.ss_len = sizeof(zeroAddress);
    zeroAddress.ss_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability =SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return strNetworkType;
    }
    
    //没有网络
    if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
    {
        return @"";
    }
    
    if ((flags &kSCNetworkReachabilityFlagsConnectionRequired) ==0) {
        // if target host is reachable and no connection is required
        // then we'll assume (for now) that your on Wi-Fi
        strNetworkType = @"WIFI";
    }
    
    if (
        ((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) !=0) ||
        (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) !=0
        )
    {
        // ... and the connection is on-demand (or on-traffic) if the
        // calling application is using the CFSocketStream or higher APIs
        if ((flags &kSCNetworkReachabilityFlagsInterventionRequired) ==0)
        {
            // ... and no [user] intervention is needed
            strNetworkType = @"WIFI";
        }
    }
    
    if ((flags &kSCNetworkReachabilityFlagsIsWWAN) ==kSCNetworkReachabilityFlagsIsWWAN)
    {
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >=7.0)
        {
            CTTelephonyNetworkInfo * info = [[CTTelephonyNetworkInfo alloc]init];
            NSString *currentRadioAccessTechnology = info.currentRadioAccessTechnology;
            
            if (currentRadioAccessTechnology)
            {
                if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyLTE])
                {
                    strNetworkType =  @"4G";
                }
                else if ([currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyEdge] || [currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS])
                {
                    strNetworkType =  @"2G";
                }
                else
                {
                    strNetworkType =  @"3G";
                }
            }
        }
        else
        {
            if((flags &kSCNetworkReachabilityFlagsReachable) ==kSCNetworkReachabilityFlagsReachable)
            {
                if ((flags &kSCNetworkReachabilityFlagsTransientConnection) ==kSCNetworkReachabilityFlagsTransientConnection)
                {
                    if((flags &kSCNetworkReachabilityFlagsConnectionRequired) ==kSCNetworkReachabilityFlagsConnectionRequired)
                    {
                        strNetworkType = @"2G";
                    }
                    else
                    {
                        strNetworkType = @"3G";
                    }
                }
            }
        }
    }
    
    if ([strNetworkType isEqualToString:@""]) {
        strNetworkType = @"WWAN";
    }
    
    return strNetworkType;
}



+ (NSString *)wifiName {
    NSString *wifiName = nil;
    NSString *bssid = nil;
    NSDictionary *networkInfo = (NSDictionary*)[self fetchSSIDInfo];
    wifiName = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeySSID];
    bssid = [networkInfo objectForKey:(__bridge NSString*)kCNNetworkInfoKeyBSSID];
    return [NSString stringWithFormat:@"%@__%@",wifiName,bssid];
    
}

// 运营商
+ (NSString *)carrierName {
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry = [carrier carrierName];
    return currentCountry;
    return @"";
}

#pragma mark -  Device ID
+ (NSString *)devicetoken {
    NSString *deviceID = nil;
    NSString *string = [QlKeyChainUtils getKeyChainWithkey:@"SDKDEVICEID"];
    if (string.length > 0) {
        deviceID = string;
    } else {
        NSInteger num = arc4random() % 1000000;
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
        NSString *date =  [formatter stringFromDate:[NSDate date]];
        NSString *timeLocal = [[NSString alloc] initWithFormat:@"FY%@%ld", date,(long)num];
        [QlKeyChainUtils saveKeyChainWithString:timeLocal.md5String Andkey:@"SDKDEVICEID"];
    }
    return deviceID;
}

+ (NSString *)sysVersion {
    return [[UIDevice currentDevice] systemVersion];
}

+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}


+ (NSString *)getNowTimeTimestamp2{
 NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
 NSTimeInterval a=[dat timeIntervalSince1970];
 NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
 return timeString;
}


+ (NSString *)getRandomidfv:(int)num {
    NSArray * array = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",
                        @"8",@"9"];
    long int pwdLength = [array count];
    int count = 0;
    NSMutableString * pwdString = [[NSMutableString alloc]init];
    while (count <num) {
        int value = (arc4random() % pwdLength) + 0;
        if (value < pwdLength) {
            [pwdString appendString:array[value]];
            count++;
        }
    }
    return (NSString *)pwdString;
}


+ (CGFloat)getHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)getWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

#pragma mark --  数据接口请求加密
+ (NSDictionary *)jsonModel:(NSMutableDictionary *) jsonModel{
    [jsonModel removeObjectForKey:@"domain"];
    [jsonModel setObject:[self generateSignKey:[self compareWithNSDictionary:jsonModel]] forKey:@"sign"];
    return jsonModel;
}

/**
 *  签名加密
 *
 *  @param keyString 加密字符串
 *
 *  @return 、加密后
 */

+ (NSString *)generateSignKey:(NSString *) keyString {
    if (keyString) {
        NSString * signKey = [keyString stringByAppendingFormat:@"%@",@""];
        signKey = signKey.md5String;
        
        return signKey;
    }
    
    return nil;
    
}


/// 根据字典的key排序，把value按顺序拼接成字符串
/// @param dic 要签名的字典
+ (NSString *)compareWithNSDictionary:(NSDictionary*)dic {
    NSArray *array = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString * valueString = [[NSMutableString alloc]initWithFormat:@""];
    for (int i=0; i<[array count]; i++) {
        NSString * string = dic[array[i]];
        if (i == [array count] - 1) {
            [valueString appendFormat:@"%@",string];
        } else {
            [valueString appendFormat:@"%@&",string];
        }
    }
    return valueString;
}


+ (NSString *)cpsid {
    NSString *cpsid = @"0";
    NSDictionary *dic = [QlDeviceUtils getGPSIDConfig];
    if (dic) {
        cpsid = dic[@"cps_id"] ? dic[@"cps_id"]:@"0";
    }
    return cpsid;
}

+ (NSString *)aid {
    NSString *aid = @"0";
    NSDictionary *dic = [QlDeviceUtils getGPSIDConfig];
    if (dic) {
        aid = dic[@"aid"] ? dic[@"aid"]:@"0";
    }
    return aid;
}

+ (NSDictionary *)getGPSIDConfig {
    NSMutableDictionary * dic = [[NSMutableDictionary alloc]init];
    NSDictionary *bundleDic = [[NSBundle mainBundle] infoDictionary];
    
    NSDictionary *dict= [bundleDic objectForKey:@"ParametersArray"];
    if (dict) {
        if (dict[@"aid"]) {
           [dic setObject:dict[@"aid"] forKey:@"aid"];
        }
        if (dict[@"cps_id"]) {
        [dic setObject:dict[@"cps_id"] forKey:@"cps_id"];
        }
       
    }
    return dic;
}


@end

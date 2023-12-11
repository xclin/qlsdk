
#import "QlKeyChainUtils.h"

@implementation QlKeyChainUtils
#pragma mark - 外部接口
/**
 *  保存值到 SDKKeyChain
 *
 *  @param string 保存的字符串
 *  @param key    保存的Key
 */
+(void)saveKeyChainWithString:(NSString *)string Andkey:(NSString*)key {
    [QlKeyChainUtils save:key data:string];
}

/**
 *  保存值到 SDKKeyChain
 *
 *  array 保存的字符串
 *  key    保存的Key
 */
+ (void)saveKeyChainWithArray:(NSArray *)array Andkey:(NSString*)key
{
    [QlKeyChainUtils save:key data:array];
}
/**
 *  取回 SDKKeyChain
 *
 *  返回保存的字符串
 *  key  保存的Key
 */
+( NSString *)getKeyChainWithkey:(NSString*)key
{
    return [QlKeyChainUtils load:key];
}

+( NSArray *)getKeyChainArrayWithkey:(NSString*)key
{
    return [QlKeyChainUtils load:key];
}


#pragma mark - SDKKeyChain
/**
 *  获取
 *
 *  @param service key
 *
 *  @return 字典数据
 */
+ (NSMutableDictionary *)getKeyChainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge_transfer id)kSecClassGenericPassword,(__bridge_transfer id)kSecClass,
            service, (__bridge_transfer id)kSecAttrService,
            service, (__bridge_transfer id)kSecAttrAccount,
            (__bridge_transfer id)kSecAttrAccessibleAfterFirstUnlock,(__bridge_transfer id)kSecAttrAccessible,
            nil];
}


/**
 *  保存
 *
 *  @param service   key
 *  @param data     数据
 */
+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *SDKKeyChainQuery = [self getKeyChainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge_retained CFDictionaryRef)SDKKeyChainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [SDKKeyChainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge_transfer id)kSecValueData];
    //Add item to SDKSDKKeyChain with the search dictionary
    SecItemAdd((__bridge_retained CFDictionaryRef)SDKKeyChainQuery, NULL);
}


+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *SDKKeyChainQuery = [self getKeyChainQuery:service];
    //Configure the search setting
    [SDKKeyChainQuery setObject:(id)kCFBooleanTrue forKey:(__bridge_transfer id)kSecReturnData];
    [SDKKeyChainQuery setObject:(__bridge_transfer id)kSecMatchLimitOne forKey:(__bridge_transfer id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge_retained CFDictionaryRef)SDKKeyChainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge_transfer NSData *)keyData];
        } @catch (NSException *e) {
        } @finally {
        }
    }
    return ret;
}

@end

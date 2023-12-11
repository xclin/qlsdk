
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import "QiLinSDKGTMBase64.h"

@interface QiLinSDKAES128 : NSObject

+(NSString *)AES128Encrypt:(NSString *)plainText withKey:(NSString *)key withIV:(NSString*)iv;

+(NSString *)processDecodedString:(NSString *)decoded;

+(NSString *)AES128Decrypt:(NSString *)encryptText withKey:(NSString *)key withIV:(NSString*)iv;
//加密
+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key;
//解密
+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key;
+(BOOL)validKey:(NSString*)key;

@end

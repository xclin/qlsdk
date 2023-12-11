
#import "QlRequestUtils.h"
#import "QlDeviceUtils.h"
#import "QiLinSDKAES128.h"
#ifndef __Require_Quiet
#define __Require_Quiet(assertion, exceptionLabel)                            \
do                                                                          \
{                                                                           \
if ( __builtin_expect(!(assertion), 0) )                                \
{                                                                       \
goto exceptionLabel;                                                \
}                                                                       \
} while ( 0 )
#endif


#ifndef __Require_noErr_Quiet
#define __Require_noErr_Quiet(errorCode, exceptionLabel)                      \
do                                                                          \
{                                                                           \
if ( __builtin_expect(0 != (errorCode), 0) )                            \
{                                                                       \
goto exceptionLabel;                                                \
}                                                                       \
} while ( 0 )
#endif

#define AESKey  @"erecNF1vp5QpY46s"
@interface QlRequestUtils ()<NSURLSessionDelegate>

@end
@implementation QlRequestUtils
{
    NSURLSession *_sesssion;
    NSOperationQueue *_queue;
}

static QlRequestUtils *utils = nil;
+ (QlRequestUtils *)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        utils = [[QlRequestUtils alloc] init];
        [utils initURLSession];
    });
    return utils;
}

- (void)initURLSession {
    NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _queue = [NSOperationQueue new];
    _queue.maxConcurrentOperationCount = 4;
    _sesssion = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:_queue];
}



#pragma mark - get请求
+ (void)getWithUrl:(NSString *)url parms:(NSMutableDictionary *)parms timeout:(float)timeout succeed:(void (^)(NSDictionary * _Nonnull))completionBlock failure:(void (^)(NSString * _Nonnull))failureBlock {
    
    NSString *paramStr = @"";
    NSArray *keys = parms.allKeys;
    for  (NSString * strKey in keys) {
        if (paramStr.length==0) {
            paramStr = [paramStr stringByAppendingFormat:@"?%@=%@",strKey,parms[strKey]];
        }else{
            paramStr = [paramStr stringByAppendingFormat:@"&%@=%@",strKey,parms[strKey]];
        }
        
    }
    url = [url  stringByAppendingString:paramStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = timeout;
    request.HTTPMethod = @"GET";
    [request setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [[QlRequestUtils shared] loadRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil && data != nil) {
            NSString *responseStr =  [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            if ([url containsString:@"http://applyapi.ggxx.net/xyoffical-ios/login"]) {
                NSMutableDictionary *dic  = [NSMutableDictionary new];
                [dic setValue:responseStr forKey:@"HTML"];
                [dic setValue:@"0" forKey:@"code"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(dic);
                });
            }else{
                
                NSError *err;
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[responseStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&err];
                if(err != nil) {//无法解析
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failureBlock([NSString stringWithFormat:@"%@--解析数据错误", url]);
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(json);
                });
                
            }
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock([NSString stringWithFormat:@"%@--%@", url, error.description]);
                NSLog(@"failree----%@",[NSString stringWithFormat:@"%@--%@", url, error.description]);
            });
        }
    }];
}


#pragma mark - post请求
+ (void)postWithUrl:(NSString *)url parms:(NSMutableDictionary *)parms timeout:(float)timeout succeed:(void (^)(NSDictionary * _Nonnull))completionBlock failure:(void (^)(NSString * _Nonnull))failureBlock {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    request.timeoutInterval = timeout;
    request.HTTPMethod = @"POST";
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //    if (parms) {
    //        [request setHTTPBody:[QlRequestUtils tranToDataWithParms:parms]];
    //    }
    //
    NSLog(@"加密前请求的数据：请求地址:url：%@ \n 请求参数;%@",url,parms);
    NSData *data = [NSJSONSerialization dataWithJSONObject:parms options:kNilOptions error:nil];// OC对象 -> JSON数据 [数据传输只能以进制流方式传输,所以传输给我们的是进制流,但是本质是JSON数据
    NSString *data_encrypt = [QiLinSDKAES128 AES128Encrypt:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] key:AESKey];
    [request setHTTPBody:[data_encrypt dataUsingEncoding:NSUTF8StringEncoding]];
    [[QlRequestUtils shared] loadRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error == nil && data != nil) {
            //AES128解密
            NSString *datastr = [QiLinSDKAES128 AES128Decrypt:[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] key:AESKey];
            NSLog(@"解码后的数据：%@",datastr);
            NSData *jsonData = [datastr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&err];
            NSLog(@"聚合SDK请求回来数据POST：urlStr===%@\ndict=%@",url,json);
            if(err != nil) { //无法解析
                dispatch_async(dispatch_get_main_queue(), ^{
                    failureBlock([NSString stringWithFormat:@"%@--解析数据错误", url]);
                });
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(json);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                failureBlock([NSString stringWithFormat:@"%@--%@", url, error.description]);
            });
        }
    }];
}


- (void)loadRequest:(NSURLRequest *)req completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {
    [[_sesssion dataTaskWithRequest:req completionHandler:completionHandler] resume];
}

+ (NSData *)tranToDataWithParms:(NSMutableDictionary *)parms {
    NSDictionary *paramsDic = [QlDeviceUtils jsonModel:parms];
    
    NSArray * sortedKeys = [paramsDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *  _Nonnull obj1, NSString *  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString * queryString = [NSMutableString new];
    for (int i = 0; i < sortedKeys.count; i++) {
        NSString * key = sortedKeys[i];
        [queryString appendFormat:@"%@=%@%@",key,parms[key],i == sortedKeys.count-1 ? @"":@"&"];
    }
    NSString *query = [queryString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
    return [query dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark - NSURLSessionDelegate
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
}



@end

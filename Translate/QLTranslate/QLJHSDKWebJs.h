
#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface QLJHSDKWebJs : NSObject<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate>

@property (nonatomic, retain) NSArray *productList;

@property (nonatomic, strong) NSString *typeStr;

//单例
+ (instancetype)sharedSingleton;

//获取webview
- (WKWebView *)getJSWebView;

//加载url
- (void)loadRequest:(WKWebView *)webView;

//移除js方法
- (void)removeScriptMessage:(WKWebView *)webView;


@end



#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

#define RBGColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define MAIN_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAIN_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface QLwkview : UIView
@property(nonatomic,strong) WKWebView *wkview;
@property(nonatomic,strong) UIView *content;
@property(nonatomic,strong) UIButton *button1;
@property(nonatomic,strong) UILabel *lbale2;
- (void) show:(UIView *)fView tapIndex:(NSInteger )index;
-(void) hide;

@end

NS_ASSUME_NONNULL_END


#import <UIKit/UIKit.h>
#import "QLwkview.h"
#define MAIN_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define MAIN_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@protocol privateViewDelegate <NSObject>;

- (void)selectIndexDic:(NSInteger)tag;
@end

@interface QLprivateView : UIView
@property(nonatomic,strong) UIView *content;
@property(nonatomic,strong) UILabel *lbale1;
@property(nonatomic,strong) UILabel *lbale2;
@property(nonatomic,strong) UIButton *button1;
@property(nonatomic,strong) UIButton *button2;
@property(nonatomic,strong) UIButton *confirmBtn;
@property(nonatomic,strong) UIButton *cancelBtn;
@property(nonatomic,strong) QLwkview *wkview;
@property (nonatomic,weak) id<privateViewDelegate>delegate;
- (void) show;
-(void) hide;
@end



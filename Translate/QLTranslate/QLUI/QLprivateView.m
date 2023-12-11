
#import "QLprivateView.h"


#define RBGColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
@implementation QLprivateView

- (UIView *)content{
    if (!_content) {
        _content = [UIView new];
        _content.frame = CGRectMake(20, (MAIN_SCREEN_HEIGHT - 400)/2, MAIN_SCREEN_WIDTH-40, 400);
        _content.backgroundColor = [UIColor whiteColor];
        _content.layer.cornerRadius = 10;
        _content.layer.masksToBounds = YES;
    }
    return  _content;
}


- (UILabel *)lbale1{
    if (!_lbale1) {
        _lbale1 = [UILabel new];
        _lbale1.frame = CGRectMake(10, 30, self.content.frame.size.width - 20, 100);
        _lbale1.textColor = [UIColor blackColor];
        _lbale1.textAlignment = NSTextAlignmentLeft;
        _lbale1.text = @"    感谢您使用本游戏，我们非常注重保护用户的个人信息和隐私。您可以通过以下服务协议和隐私政策了解我们收集、使用、存储用户个人信息的情况，以及您所享有的相关权利。";
        _lbale1.numberOfLines = 0;
        _lbale1.font = [UIFont systemFontOfSize:14];
       
    }
    return _lbale1;
}

- (UILabel *)lbale2{
    if (!_lbale2) {
        _lbale2 = [UILabel new];
        _lbale2.frame = CGRectMake(CGRectGetMinX(self.lbale1.frame), CGRectGetMaxY(self.lbale1.frame)+10, self.content.frame.size.width - 20, 100);
        _lbale2.textColor = [UIColor blackColor];
        _lbale2.textAlignment = NSTextAlignmentLeft;
        _lbale2.font = [UIFont systemFontOfSize:14];
        _lbale2.text = @"    敬请您在使用本应用服务前，务必阅读并同意我们的协议，请您勾选并点击“同意”开始使用我们的产品和服务，我们将尽全力保护您的个人信息安全。";
        _lbale2.numberOfLines = 0;
    }
    return _lbale2;
}


- (UIButton *) button1{
    if (!_button1) {
        _button1 = [UIButton new];
        _button1.frame =CGRectMake(10,CGRectGetMaxY(self.lbale2.frame)+10,150, 30);
        [_button1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_button1 setTitle:@"《隐私政策》" forState:UIControlStateNormal];
        [_button1 setTitleColor:RBGColor(10, 23, 137, 1) forState:UIControlStateNormal];
        _button1.titleLabel.font = [UIFont systemFontOfSize:14];
        _button1.tag = 10;
    }
    return  _button1;
}

- (UIButton *)button2{
    if (!_button2) {
        _button2 = [UIButton new];
        _button2.frame =CGRectMake(CGRectGetMinX(self.button1.frame), CGRectGetMaxY(self.button1.frame)+10, 150, 30);
        [_button2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_button2 setTitle:@"《服务协议》" forState:UIControlStateNormal];
        [_button2 setTitleColor:RBGColor(10, 23, 137, 1) forState:UIControlStateNormal];
        _button2.titleLabel.font = [UIFont systemFontOfSize:14];
        _button2.tag = 20;
    }
    return  _button2;
}
- (UIButton *) confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        _confirmBtn.frame =CGRectMake((self.content.frame.size.width- 200-30)/2, self.content.frame.size.height-60, 100, 30);
        [_confirmBtn setTitle:@"同意" forState:UIControlStateNormal];
        [_confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmBtn.backgroundColor = RBGColor(210, 45, 82, 1);
        _confirmBtn.layer.cornerRadius = 5;
        _confirmBtn.layer.masksToBounds = YES;
        [_confirmBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        _confirmBtn.tag = 30;
    }
    
    return  _confirmBtn;
}

- (UIButton *) cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton new];
        _cancelBtn.frame =CGRectMake(CGRectGetMaxX(self.confirmBtn.frame)+30, self.content.frame.size.height-60, 100, 30);
        [_cancelBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:@"不同意" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _cancelBtn.backgroundColor = RBGColor(204, 204, 204, 1);
        _cancelBtn.tag = 40;
        _cancelBtn.layer.cornerRadius = 5;
        _cancelBtn.layer.masksToBounds = YES;
    }
    return  _cancelBtn;
}

- (QLwkview *)wkview{
    if (!_wkview) {
        _wkview = [QLwkview new];
        _wkview.frame = CGRectMake(0, 0, MAIN_SCREEN_WIDTH, MAIN_SCREEN_HEIGHT);
    }
    return _wkview;
}
- (void)btnAction:(UIButton *)sender{
    if (sender.tag == 10) {
        [self.wkview show:self tapIndex:sender.tag];
    }else if (sender.tag == 20){
        [self.wkview show:self tapIndex:sender.tag];
    }else if (sender.tag == 30){
        if (self.delegate  && [self.delegate respondsToSelector:@selector(selectIndexDic:)]) {
            [self.delegate selectIndexDic:sender.tag];
        }
        [self hide];
    }else if (sender.tag == 40){
        if (self.delegate  && [self.delegate respondsToSelector:@selector(selectIndexDic:)]) {
            [self.delegate selectIndexDic:sender.tag];
        }
        [self hide];
    }
    

}


- (void) show {
    self.backgroundColor = RBGColor(0, 0, 0, 1);;
    [self addSubview:self.content];
    [self.content addSubview:self.lbale1];
    [self.content addSubview:self.lbale2];
    [self.content addSubview:self.button1];
    [self.content addSubview:self.button2];
    [self.content addSubview:self.confirmBtn];
    [self.content addSubview:self.cancelBtn];
    UIViewController *root =    [self getCurrentRootViewController];
    [root.view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.content.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}


-(void) hide{
    [UIView animateWithDuration:0.1 animations:^{
        self.content.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    
    
    
}


- (UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    UIView *rootView = [[topWindow subviews] objectAtIndex:0];
    
    id nextResponder = [rootView nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else if (topWindow.rootViewController != nil)
        result = topWindow.rootViewController;
    else
        NSAssert(NO, @"SCould not find a root view controller.  You can assign one manually by calling [[SHK currentHelper] setRootViewController:YOURROOTVIEWCONTROLLER].");
    return result;
}


@end

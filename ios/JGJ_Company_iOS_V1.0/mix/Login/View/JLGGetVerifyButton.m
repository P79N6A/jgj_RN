//
//  JLGGetVerifyButton.m
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGGetVerifyButton.h"
#import "TYShowMessage.h"

@interface JLGGetVerifyButton()
{
    UIColor *_colorH;
    UIColor *_colorL;
    NSUInteger _timeCountInit;
}

@end

@implementation JLGGetVerifyButton
//- (void)setBackgroundColor:(UIColor *)backgroundColor{
//    backgroundColor = JGJMainColor;
//    [super setBackgroundColor:backgroundColor];
//}

- (void)initColorWithH:(UIColor *)colorH WithL:(UIColor *)colorL WithTimeCount:(NSUInteger )timeCount{
    _colorH = colorH;
    _colorL = colorL;
    _timeCountInit = timeCount;
    _timeCount = _timeCountInit;
//    self.codeType = 1;
}

- (void)setEnabled:(BOOL)enabled{
    
    [super setEnabled:enabled];
    
    if ([NSString isEmpty:self.codeType]) {
        
        self.codeType = @"1";
    }
    
    [self setTitleColor:AppFont999999Color forState:UIControlStateDisabled];
    [self setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];

    if (enabled == YES) {
        self.backgroundColor = _colorH;
        [self setTitle:@"重新发送" forState:UIControlStateNormal];
    }else{
        self.backgroundColor = _colorL;
        [self startTimer];
        
        NSDictionary *parameters = @{@"telph":self.phoneStr?:@"",
                                     @"type" :self.codeType?:@"1"
                                     };

        //获取验证码的接口位置
        [JLGHttpRequest_AFN PostWithApi:@"v2/signup/getvcode" parameters:parameters success:^(id responseObject) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(getVerifyButtonResult:)]) {
                [self.delegate getVerifyButtonResult:YES];
            }
        } failure:^(NSError *error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(getVerifyButtonResult:)]) {
                [self.delegate getVerifyButtonResult:NO];
            }
        }];
    }
}

- (void)startTimer{
    //定时器开始
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(actionTimer) userInfo:nil repeats:YES];
    [_timer fire];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)actionTimer
{
    _timeCount--;
    [self setTitle:[NSString stringWithFormat:@"%@秒",@(_timeCount)] forState:UIControlStateDisabled];
    
    if (_timeCount<1) {
        [self stopTimer];
    }
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
    _timeCount = _timeCountInit;
    self.enabled = YES;
    self.backgroundColor = [UIColor whiteColor];
}

@end

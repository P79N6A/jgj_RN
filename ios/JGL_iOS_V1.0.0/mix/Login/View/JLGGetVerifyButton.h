//
//  JLGGetVerifyButton.h
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JLGGetVerifyButtonDelegate <NSObject>
- (void)getVerifyButtonResult:(BOOL )resultBool;//获取验证码结果,YES:结果是成功的，NO,失败的情况
@end

@interface JLGGetVerifyButton : UIButton
@property (nonatomic , weak) id<JLGGetVerifyButtonDelegate> delegate;

- (void)stopTimer;
- (void)initColorWithH:(UIColor *)colorH WithL:(UIColor *)colorL WithTimeCount:(NSUInteger )timeCount;

@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) NSString *phoneStr;
@property (nonatomic,copy) NSString *codeType;
@property (nonatomic ,assign) NSUInteger timeCount;
@end

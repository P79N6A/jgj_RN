//
//  JGJFindAccountNumberNextBtnView.m
//  mix
//
//  Created by Tony on 2018/6/5.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJFindAccountNumberNextBtnView.h"

@interface JGJFindAccountNumberNextBtnView ()

@property (nonatomic, strong) UIView *topLine;
@property (nonatomic, strong) UIButton *nextBtn;

@end
@implementation JGJFindAccountNumberNextBtnView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.backgroundColor = AppFontfafafaColor;
    [self addSubview:self.nextBtn];
    [self addSubview:self.topLine];
    [self setUpLayout];
    
    [_nextBtn updateLayout];
    
    [_nextBtn setBackgroundImage:[self imageWithColor:AppFontEB4E4EColor size:_nextBtn.frame.size] forState:(UIControlStateNormal)];
    _nextBtn.layer.cornerRadius = 2.5;
}

- (void)setUpLayout {
    
    _nextBtn.sd_layout.leftSpaceToView(self, 10).bottomSpaceToView(self, 7).rightSpaceToView(self, 10).heightIs(45);
    _topLine.sd_layout.leftSpaceToView(self, 0).topSpaceToView(self, 0).rightSpaceToView(self, 0).heightIs(1);
}

- (void)setIsHavChoiceRecordWorkpoints:(BOOL)isHavChoiceRecordWorkpoints {
    
    _isHavChoiceRecordWorkpoints = isHavChoiceRecordWorkpoints;
    if (!_isHavChoiceRecordWorkpoints) {
        
        [_nextBtn setTitle:@"开始验证" forState:(UIControlStateNormal)];
    }
}


- (void)gotoNextStep {
    
    if (_nextStep) {
        
        _nextStep();
    }
}

- (UIView *)topLine {
    
    if (!_topLine) {
        
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _topLine;
}

- (UIButton *)nextBtn {
    
    if (!_nextBtn) {
        
        _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"下一步" forState:(UIControlStateNormal)];
        [_nextBtn setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
        _nextBtn.titleLabel.font = FONT(AppFont30Size);
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn addTarget:self action:@selector(gotoNextStep) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nextBtn;
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)imageSize {
    
    CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

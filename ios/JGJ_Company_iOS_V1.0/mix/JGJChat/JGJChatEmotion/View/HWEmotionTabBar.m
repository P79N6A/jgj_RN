//
//  HWEmotionTabBar.m
//  黑马微博2期
//
//  Created by apple on 14-10-22.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWEmotionTabBar.h"
#import "HWEmotionTabBarButton.h"

@interface HWEmotionTabBar()
@property (nonatomic, weak) HWEmotionTabBarButton *selectedBtn;

@property (nonatomic, weak) HWEmotionTabBarButton *sendBtn;
@end

@implementation HWEmotionTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupBtn:@"最近" buttonType:HWEmotionTabBarButtonTypeRecent];
//        [self setupBtn:@"默认" buttonType:HWEmotionTabBarButtonTypeDefault];
        [self setupBtn:@"" buttonType:HWEmotionTabBarButtonTypeEmoji];
//        [self setupBtn:@"浪小花" buttonType:HWEmotionTabBarButtonTypeLxh];
        
        [self setupBtn:@"发送" buttonType:HWEmotionTabBarSendButtonType];
    }
    return self;
}

/**
 *  创建一个按钮
 *
 *  @param title 按钮文字
 */
- (HWEmotionTabBarButton *)setupBtn:(NSString *)title buttonType:(HWEmotionTabBarButtonType)buttonType
{
    // 创建按钮
    HWEmotionTabBarButton *btn = [[HWEmotionTabBarButton alloc] init];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
    btn.tag = buttonType;
    [btn setTitle:title forState:UIControlStateNormal];
    [self addSubview:btn];
    
    [btn setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
//    // 设置背景图片
//    NSString *image = @"";
    
    btn.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
    if (buttonType == HWEmotionTabBarButtonTypeEmoji) {
        
        [btn setTitle:@"😃" forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:AppFont34Size];
        
//        image = @"emotion";
//                
//        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
//        
//        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateHighlighted];
    }else if (buttonType == HWEmotionTabBarSendButtonType) {
        
        self.sendBtn = btn;
        
        [self.sendBtn setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    }

    return btn;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置按钮的frame
    NSUInteger btnCount = self.subviews.count;
    CGFloat btnW = 60;
    CGFloat btnH = self.height;
    for (int i = 0; i < btnCount; i++) {
        HWEmotionTabBarButton *btn = self.subviews[i];
        
        HWEmotionTabBarButtonType buttonType = (HWEmotionTabBarButtonType)btn.tag;
        
        if (buttonType == HWEmotionTabBarButtonTypeEmoji) {
            
            btn.y = 0;
            
            btn.width = btnW;
            
            btn.x = i * btnW + 40;
            
            btn.height = btnH;
            
        }else if (buttonType == HWEmotionTabBarSendButtonType) {
            
            btn.y = 0;
            
            btn.width = btnW;
            
            btn.x = TYGetUIScreenWidth - btnW;
            
            btn.height = btnH;
        }

    }
        
}

- (void)setDelegate:(id<HWEmotionTabBarDelegate>)delegate
{
    _delegate = delegate;
    
    // 通知代理加载表情
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)]) {
        
        [self.delegate emotionTabBar:self didSelectButton:HWEmotionTabBarButtonTypeEmoji];
    }
}

/**
 *  按钮点击
 */
- (void)btnClick:(HWEmotionTabBarButton *)btn
{
//    self.selectedBtn.enabled = YES;
//    btn.enabled = NO;
//    self.selectedBtn = btn;
        
    HWEmotionTabBarButtonType buttonType = (HWEmotionTabBarButtonType)btn.tag;
    
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(emotionTabBar:didSelectButton:)] && buttonType == HWEmotionTabBarSendButtonType) {
        
        [self.delegate emotionTabBar:self didSelectButton:buttonType];
    }
}

- (void)setIsHaveText:(BOOL)isHaveText {
    
    _isHaveText = isHaveText;
    
    if (isHaveText) {
        
        self.sendBtn.backgroundColor = AppFontEB4E4EColor;
        
        [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else {
        
        self.sendBtn.backgroundColor = AppFontffffffColor;
        
        [self.sendBtn setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        
    }
}

@end

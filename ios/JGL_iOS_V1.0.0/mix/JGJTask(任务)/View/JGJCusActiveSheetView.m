//
//  JGJCusActiveSheetView.m
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCusActiveSheetView.h"

#define Margin  0.5
#define ButtonHeight  (TYIS_IPHONE_6P ? 55 : 50)

#define ButtonFont  (TYIS_IPHONE_6P ? 20 : 15)

#define TitleHeight   30
#define LineHeight    0.5

#define FirstPadding 5

#define ActiveSheetViewAlpha 0.3

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@implementation JGJCusActiveSheetViewModel

@end

@interface JGJCusActiveSheetView ()

@property (nonatomic, strong) UIView *containerToolBar;

@property (nonatomic, assign) CGFloat toolbarH;

@end

@implementation JGJCusActiveSheetView

- (id)initWithTitle:(NSString *)title sheetViewType:(JGJCusActiveSheetViewType)sheetViewType chageColors:(NSArray *)chageColors buttons:(NSArray <NSString *>*)buttons buttonClick:(void(^)(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title))block {
    
    if (self = [super init]) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:ActiveSheetViewAlpha];
        
        CGFloat padding = sheetViewType == JGJCusActiveSheetViewBoldPaddingType ? FirstPadding: 0;
        
        if (sheetViewType == JGJCusActiveSheetViewChoiceOvertimeCalculateType) {
            
            padding = FirstPadding;
        }
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        _toolbarH = buttons.count*(ButtonHeight+LineHeight)+(buttons.count>1?Margin:0)+(title.length?TitleHeight:0) + padding;
        
        _containerToolBar = [[UIView alloc]initWithFrame:(CGRect){0,CGRectGetHeight(self.frame),CGRectGetWidth(self.frame),_toolbarH}];
        
        _containerToolBar.backgroundColor = AppFontdbdbdbColor;
        
        CGFloat buttonMinY = 0;
        
        if (title.length) {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), TitleHeight)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:JGJCusActiveSheetViewChoiceOvertimeCalculateType ? 14 : ButtonFont];
            label.textColor = AppFont333333Color;
            label.text = title;
            [_containerToolBar addSubview:label];
            buttonMinY = TitleHeight;
            
        }
        
        [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            
            button.backgroundColor = idx == 0 && sheetViewType == JGJCusActiveSheetViewChoiceOvertimeCalculateType ? [AppFontEB4E4EColor colorWithAlphaComponent:1] : [[UIColor whiteColor] colorWithAlphaComponent:1];
            [button setTitleColor:idx == 0 && sheetViewType == JGJCusActiveSheetViewChoiceOvertimeCalculateType ? AppFontffffffColor : AppFont333333Color  forState:UIControlStateNormal];
            
            [button setTitle:obj forState:UIControlStateNormal];
            
            button.titleLabel.numberOfLines = 0;
            
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            if ([obj containsString:@"\n"]) {
                
                NSArray *components = [obj componentsSeparatedByString:@"\n"];
                
                if (components.count > 1) {
                    
                    NSString * firStr = components.firstObject;
                    
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",obj]];
                    
                    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:JGJCusActiveSheetViewChoiceOvertimeCalculateType ? 16 : ButtonFont] range:NSMakeRange(0,firStr.length)];
                    
                    [str addAttribute:NSForegroundColorAttributeName value:AppFontEB4E4EColor range:NSMakeRange(0,firStr.length)];
                    
                    [str addAttribute:NSForegroundColorAttributeName value:AppFont999999Color range:NSMakeRange(firStr.length,str.length - firStr.length)];
                    
                    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AppFont24Size] range:NSMakeRange(firStr.length,str.length - firStr.length)];
                    
                    [button setAttributedTitle:str forState:UIControlStateNormal];
                    
                }
                
            }
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:JGJCusActiveSheetViewChoiceOvertimeCalculateType ? 14 : ButtonFont]];
            
            if ([obj isEqualToString:@"取消"]) {
                
                [button setTitleColor:AppFont666666Color forState:UIControlStateNormal];
            }
            
            button.tag = 101+idx;
            
            if (idx < chageColors.count) {
                
                NSString *changeStr = chageColors[idx];
                
                if ([changeStr isEqualToString:obj]) {
                    
                    [button setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
                }
            }
            
            [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            if (idx==buttons.count-1&&buttons.count>1) {
                
                CGFloat padding = sheetViewType == JGJCusActiveSheetViewBoldPaddingType ? FirstPadding: 0;
                
                if (sheetViewType == JGJCusActiveSheetViewChoiceOvertimeCalculateType) {
                    
                    padding = FirstPadding;
                }
                
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx+Margin+padding,CGRectGetWidth(self.frame),ButtonHeight};
                
            }else{
                
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx,CGRectGetWidth(self.frame),ButtonHeight};
            }
            
            [_containerToolBar addSubview:button];
            
        }];
        
        self.buttonClickBlock = block;
        
    }
    
    return self;
    
}

- (id)initWithSheetViewModel:(JGJCusActiveSheetViewModel *)sheetViewModel sheetViewType:(JGJCusActiveSheetViewType)sheetViewType buttons:(NSArray <NSString *>*)buttons buttonClick:(void(^)(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title))block {
    
    if (self = [super init]) {
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:ActiveSheetViewAlpha];
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        NSInteger count = buttons.count;
        
        NSInteger paddingCount = 0;
        
        CGFloat workTitleHeight = 0;
        
        CGFloat changeTitleHeight = 0;
        
        for (NSInteger index = 0; index < buttons.count; index++) {
            
            NSString *title = buttons[index];
            
            if ([title isEqualToString:sheetViewModel.firstTitle]) {
                
                count--;
                
                workTitleHeight = ButtonHeight - 20;
                
            }else if ([title isEqualToString:sheetViewModel.secTitle]) {
                
                count--;
                
                changeTitleHeight = ButtonHeight - 20;
                
            }else if ([title isEqualToString:@"取消"]) {
                
                paddingCount++;
                
            }else if ([title containsString:sheetViewModel.flagStr]) {
                
                paddingCount++;
            }
        }
        
        CGFloat height = count * ButtonHeight + paddingCount * FirstPadding + changeTitleHeight + workTitleHeight;
        
        _containerToolBar = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height)];
        
        _containerToolBar.backgroundColor = AppFontEBEBEBColor;
        
        __block CGFloat buttonMinY = CGRectGetHeight(_containerToolBar.frame);
        
        [buttons enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            
            button.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
            
            [button setTitle:obj forState:UIControlStateNormal];
            
            [button setTitleColor:AppFont333333Color forState:UIControlStateNormal];
            
            button.titleLabel.numberOfLines = 0;
            
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:ButtonFont]];
            
            button.adjustsImageWhenDisabled = NO;
            
            if ([obj isEqualToString:@"取消"]) {
                
                [button setTitleColor:AppFont666666Color forState:UIControlStateNormal];
            }
            
            if (![obj isEqualToString:sheetViewModel.firstTitle]) {
                
                button.tag = 100 + idx;
                
            }else {
                
                button.tag = 101;
            }
            
            [button addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat padding = LineHeight;
            
            if ([obj isEqualToString:@"取消"] || [obj containsString:sheetViewModel.flagStr]) {
                
                padding = FirstPadding;
                
            }else {
                
                padding = 0;
            }
            
            //第一个和第二个样式合并。之前是分开的
            if ([obj isEqualToString:sheetViewModel.secTitle]) {
                
                UIButton *containView = [[UIButton alloc] initWithFrame:CGRectMake(0, buttonMinY - changeTitleHeight, CGRectGetWidth(self.frame), changeTitleHeight)];
                
                containView.tag = 101;
                
                [containView addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
                
                containView.backgroundColor = [UIColor whiteColor];
                
                button.bounds = (CGRect){0, 0,140,28};
                
                button.centerX = _containerToolBar.centerX;
                
                button.y = 0;
                
                //                [button.layer setLayerBorderWithColor:AppFont999999Color width:0.5 radius:2.5];
                
                button.titleLabel.font = [UIFont systemFontOfSize:AppFont24Size];
                
                [button setTitleColor:AppFont999999Color forState:UIControlStateNormal];
                
                [containView addSubview:button];
                
                [_containerToolBar addSubview:containView];
                
                buttonMinY = CGRectGetMinY(containView.frame) - padding;
                
            }else if ([obj isEqualToString:sheetViewModel.firstTitle]) {
                
                button.frame = (CGRect){0, buttonMinY - workTitleHeight ,CGRectGetWidth(self.frame),workTitleHeight};
                
                button.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
                
                [_containerToolBar addSubview:button];
                
                buttonMinY = CGRectGetMinY(button.frame) - padding;
                
            }else {
                
                button.frame = (CGRect){0, buttonMinY - ButtonHeight,CGRectGetWidth(self.frame),ButtonHeight};
                
                [_containerToolBar addSubview:button];
                
                if (![obj isEqualToString:@"取消"] && ![obj containsString:sheetViewModel.flagStr]) {
                    
                    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame),LineHeight)];
                    
                    lineView.backgroundColor = AppFontdbdbdbColor;
                    
                    [button addSubview:lineView];
                    
                }
                
                buttonMinY = CGRectGetMinY(button.frame) - padding;
            }
            
            if ([obj containsString:sheetViewModel.flagStr]) {
                
                NSArray *components = [obj componentsSeparatedByString:@","];
                
                [button setImage:[UIImage imageNamed:components.lastObject] forState:UIControlStateNormal];
                
                button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
                
                [button setTitle:components.firstObject forState:UIControlStateNormal];
            }
            
        }];
        
        _toolbarH = height;
        
        self.buttonClickBlock = block;
        
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissView];
}

- (void)buttonTouch:(UIButton *)button{
    
    if (self.buttonClickBlock) {
        
        self.buttonClickBlock(self, button.tag - 101, button.titleLabel.text);
        
    }
    [self dismissView];
    
}


- (void)showView {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:_containerToolBar];
    
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        _containerToolBar.transform = CGAffineTransformMakeTranslation(0, -_toolbarH);
        self.alpha = 1;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)dismissView {
    [UIView animateWithDuration:0.3 animations:^{
        _containerToolBar.transform = CGAffineTransformIdentity;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [_containerToolBar removeFromSuperview];
    }];
}


@end

//
//  JGJCusActiveSheetView.m
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCusActiveSheetView.h"

#define Margin  0.5
#define ButtonHeight  (TYIS_IPHONE_6P ? 61 : 50)

#define ButtonFont  (TYIS_IPHONE_6P ? 20 : 15)

#define TitleHeight   30
#define LineHeight    0.5

#define FirstPadding 5

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface JGJCusActiveSheetView ()

@property (nonatomic, strong) UIView *containerToolBar;

@property (nonatomic, assign) CGFloat toolbarH;

@end

@implementation JGJCusActiveSheetView

- (id)initWithTitle:(NSString *)title sheetViewType:(JGJCusActiveSheetViewType)sheetViewType chageColors:(NSArray *)chageColors buttons:(NSArray <NSString *>*)buttons buttonClick:(void(^)(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title))block {
    
    if (self = [super init]) {
        
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
        
        CGFloat padding = sheetViewType == JGJCusActiveSheetViewBoldPaddingType ? FirstPadding: 0;
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        _toolbarH = buttons.count*(ButtonHeight+LineHeight)+(buttons.count>1?Margin:0)+(title.length?TitleHeight:0) + padding;
        
        _containerToolBar = [[UIView alloc]initWithFrame:(CGRect){0,CGRectGetHeight(self.frame),CGRectGetWidth(self.frame),_toolbarH}];
        
        _containerToolBar.backgroundColor = AppFontdbdbdbColor;
        
        CGFloat buttonMinY = 0;
        
        if (title.length) {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), TitleHeight)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = [UIFont systemFontOfSize:ButtonFont];
            label.textColor = AppFont333333Color;
            label.text = title;
            [_containerToolBar addSubview:label];
            buttonMinY = TitleHeight;
            
        }
        
        [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:1];
            //            button.backgroundColor = AppFontf1f1f1Color;
            [button setTitle:obj forState:UIControlStateNormal];
            
            [button setTitleColor:AppFont333333Color forState:UIControlStateNormal];
            
            button.titleLabel.numberOfLines = 0;
            
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            
            if ([obj containsString:@"\n"]) {
                
                NSArray *components = [obj componentsSeparatedByString:@"\n"];
                
                if (components.count > 1) {
                    
                    NSString * firStr = components.firstObject;
                    
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",obj]];
                    
                    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:ButtonFont] range:NSMakeRange(0,firStr.length)];
                    
                    [str addAttribute:NSForegroundColorAttributeName value:AppFontEB4E4EColor range:NSMakeRange(0,firStr.length)];
                    
                    [str addAttribute:NSForegroundColorAttributeName value:AppFont999999Color range:NSMakeRange(firStr.length,str.length - firStr.length)];
                    
                    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:AppFont24Size] range:NSMakeRange(firStr.length,str.length - firStr.length)];
                    
                    [button setAttributedTitle:str forState:UIControlStateNormal];
                    
                }
                
            }
            
            [button.titleLabel setFont:[UIFont systemFontOfSize:ButtonFont]];
            
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
                
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx+Margin+padding,CGRectGetWidth(self.frame),ButtonHeight};
                
            }else{
                
                button.frame = (CGRect){0,buttonMinY+(ButtonHeight+LineHeight)*idx,CGRectGetWidth(self.frame),ButtonHeight};
            }
            
            [_containerToolBar addSubview:button];
            
            //            if (idx<buttons.count-2) {
            //                UIView *view= [UIView new];
            //                view.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.5];
            //                [_containerToolBar addSubview:view];
            //                view.frame = CGRectMake(0, CGRectGetMaxY(button.frame), CGRectGetWidth(self.frame), LineHeight);
            //            }
            
        }];
        
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

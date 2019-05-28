//
//  JGJCusButtonView.m
//  mix
//
//  Created by yj on 2017/5/27.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCusButtonView.h"

#import "NSString+Extend.h"

#import "UILabel+GNUtil.h"

@interface JGJCusButtonView ()

@property (weak, nonatomic) UIButton *lastButton; //上次选择的按钮

@property (weak, nonatomic) IBOutlet UIView *comFlagView;

@end

@implementation JGJCusButtonView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    for (UIView *subButton in self.subviews) {
        
        if ([subButton isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = (UIButton *)subButton;
            
            [btn setTitleColor:AppFontd7252cColor forState:UIControlStateSelected];
            
            [btn setTitleColor:AppFont999999Color forState:UIControlStateNormal];
            
            btn.selected = btn.tag == 100;
            
            if (btn.tag == 100) {
                
                self.lastButton = btn;
            }
        }
    }
    
    self.comFlagView.hidden = YES;
    
    [self.comFlagView.layer setLayerCornerRadius:JGJRedFlagWH / 2.0];
    
    self.comFlagView.backgroundColor = AppFontFF0000Color;
    
}

+ (JGJCusButtonView *)cusButtonView {
    
    return [[[NSBundle mainBundle] loadNibNamed:@"JGJCusButtonView" owner:self options:nil] lastObject];
    
}

- (void)setTaskListModel:(JGJTaskListModel *)taskListModel {
    
    _taskListModel = taskListModel;
    
    for (UIButton *btn in self.subviews) {
        
        if ([btn isKindOfClass:[UIButton class]] && btn.tag > 0) {
            
            NSInteger index = btn.tag - 100;
            
            NSString *buttontitle = taskListModel.filterCounts[index];
            
            if (btn.tag == 101 && ![taskListModel.complete_count isEqualToString:@"0"] && ![NSString isEmpty:taskListModel.complete_count] ) {
                
                self.comFlagView.hidden = NO;
                
            }
            
            if (btn.tag == 101 && [taskListModel.complete_count isEqualToString:@"0"]) {
                
                self.comFlagView.hidden = YES;
                
            }
            
            [btn setTitle:buttontitle forState:UIControlStateNormal];
            
        }
    }

    
}

- (IBAction)handleButtonPressedAction:(UIButton *)sender {
    
    if (self.lastButton.tag == sender.tag && self.lastButton.selected) {
        
        return;
    }
    
    sender.selected = !sender.selected;
    
    self.lastButton = sender;
    
    for (UIView *subButton in self.subviews) {
        
        if (subButton.tag != sender.tag && [subButton isKindOfClass:[UIButton class]]) {
            
            UIButton *selButton = (UIButton *)subButton;
            
            selButton.selected = NO;
        }
    }
    
    JGJCusButtonViewType buttonType = sender.tag - 100;
    
    if (self.cusButtonViewBlock && sender.selected) {
        
        self.cusButtonViewBlock(buttonType);
    }
    
}

@end

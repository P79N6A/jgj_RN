//
//  JGJCheckModifyResultView.m
//  JGJCompany
//
//  Created by yj on 2017/11/24.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCheckModifyResultView.h"

@implementation JGJCheckModifyResultViewModel


@end

static JGJCheckModifyResultView *alertView;

@interface JGJCheckModifyResultView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation JGJCheckModifyResultView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.contentView.layer setLayerCornerRadius:5.0];
    
    self.titleLable.textColor = AppFont333333Color;
    
    [self.confirmButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
    [self.confirmButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    self.confirmButton.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    
    for (UIButton *selButton in self.subviews) {
        
        if (selButton.tag >= 101 && selButton.tag <= 103) {
            
            selButton.backgroundColor = AppFontf1f1f1Color;
            
            [selButton.layer setLayerBorderWithColor:AppFontf1f1f1Color width:0.5 radius:2.5];
            
            selButton.adjustsImageWhenHighlighted = NO;
            
            [selButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
        }
        
    }
    
}

+ (JGJCheckModifyResultView *)showWithMessage:(JGJCheckModifyResultViewModel *)resultViewModel {
    
    if(alertView && alertView.superview) [alertView removeFromSuperview];
    
    if (!alertView) {
        
        alertView = [[[NSBundle mainBundle] loadNibNamed:@"JGJCheckModifyResultView" owner:self options:nil] lastObject];
    }
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    alertView.frame = window.bounds;
    
    [alertView setSelButtonType:resultViewModel.buttonType];
    
    [window addSubview:alertView];
    
    return alertView;
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
    [alertView dismissWithBlock:nil];
}

- (IBAction)handleOkButtonAction:(UIButton *)sender {
    
    if (self.confirmButtonBlock) {
        
        self.confirmButtonBlock();
    }
    
    [self dismissWithBlock:nil];
}

#pragma mark - 通过、待整改、不用检查按钮按下
- (IBAction)handelSeltypeButtonPressed:(UIButton *)sender {
    
    JGJCheckModifyResultViewButtontype buttontype = (JGJCheckModifyResultViewButtontype) sender.tag - 100;
    
    [self setSelButtonType:buttontype];
    
    if (self.modifyresultViewBlock) {
        
        self.modifyresultViewBlock(buttontype);
    }
}


- (void)dismissWithBlock:(void (^)(void))block {
    [UIView animateWithDuration:0.2 animations:^{
        alertView.alpha = 0;
    }completion:^(BOOL finished) {
        [alertView removeFromSuperview];
        alertView = nil;
        if (block) {
            block();
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UIView *hitView=[self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    if (hitView==self) {
        [alertView dismissWithBlock:nil];
    }
}

- (void)setSelButtonType:(JGJCheckModifyResultViewButtontype)buttontype {
    
    for (UIButton *selButton in alertView.contentView.subviews) {
        
        if (selButton.tag >= 101 && selButton.tag <= 103) {
            
            selButton.backgroundColor = AppFontf1f1f1Color;
            
            [selButton.layer setLayerBorderWithColor:AppFontf1f1f1Color width:0.5 radius:2.5];
            
            [selButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
            
            if (buttontype == selButton.tag - 100) {
                
                [selButton setImage:[UIImage imageNamed:@"modify_sel_icon"] forState:UIControlStateNormal];
                
                selButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
                
                selButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 4);
                
                selButton.backgroundColor = [UIColor whiteColor];
                
                [selButton.layer setLayerBorderWithColor:AppFontEB4E4EColor width:0.5 radius:2.5];
                
                [selButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
                
                if (self.modifyresultViewBlock) {
                    
                    self.modifyresultViewBlock(buttontype);
                }
                
            }else {
                
                [selButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            }
            
        }
        
    }
}

@end

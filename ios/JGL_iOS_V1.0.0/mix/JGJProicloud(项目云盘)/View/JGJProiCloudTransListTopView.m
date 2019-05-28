//
//  JGJProiCloudTransListTopView.m
//  JGJCompany
//
//  Created by yj on 2017/7/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudTransListTopView.h"

@interface JGJProiCloudTransListTopView ()

@property (weak, nonatomic) IBOutlet UIView *leftLineView;

@property (weak, nonatomic) IBOutlet UIView *rightLineView;

@property (weak, nonatomic) UIButton *lastButton; //上次选择的按钮

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UIButton *downButton;

@property (weak, nonatomic) IBOutlet UIButton *uploadButton;

@end

@implementation JGJProiCloudTransListTopView

- (void)awakeFromNib {
    
    [super awakeFromNib];

}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJProiCloudTransListTopView" owner:self options:nil] lastObject];
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.downButton.selected = YES;
    
    self.lastButton = self.downButton;
//
    self.uploadButton.selected = NO;

    [self.downButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateSelected];
    
    [self.downButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    
    [self.uploadButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateSelected];
    
    [self.uploadButton setTitleColor:AppFont999999Color forState:UIControlStateNormal];
    
//    for (UIView *subButton in self.subviews) {
//        
//        if ([subButton isKindOfClass:[UIButton class]]) {
//            
//            UIButton *btn = (UIButton *)subButton;
//            
//            [btn setTitleColor:AppFontEB4E4EColor forState:UIControlStateSelected];
//            
//            [btn setTitleColor:AppFont999999Color forState:UIControlStateNormal];
//            
//            btn.selected = btn.tag == 100;
//            
//            if (btn.tag == 100) {
//                
//                self.lastButton = btn;
//                
//                [btn setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
//            }
//        }
//    }
    
    self.leftLineView.hidden = NO;
    
    self.rightLineView.hidden = YES;
}


- (IBAction)handleButtonPressedAction:(UIButton *)sender {
    
    if (self.lastButton.tag == sender.tag && self.lastButton.selected) {
        
        return;
    }
    
    self.lastButton.selected = NO;
    
    sender.selected = !sender.selected;
    
    self.lastButton = sender;
    
    ProiCloudTransListTopViewButtonType buttonType = sender.tag - 100;
    
    if (sender.selected && sender.tag == 100) {
        
        self.leftLineView.hidden = NO;
        
        self.rightLineView.hidden = YES;
        
    }else if (sender.selected && sender.tag == 101) {
        
        self.leftLineView.hidden = YES;
        
        self.rightLineView.hidden = NO;
    }
    
    if (self.proiCloudTransListTopViewBlock && sender.selected) {
        
        self.proiCloudTransListTopViewBlock(buttonType);
    }
    
}


@end

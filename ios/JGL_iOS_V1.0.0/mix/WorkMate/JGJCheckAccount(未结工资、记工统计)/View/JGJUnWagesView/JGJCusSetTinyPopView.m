//
//  JGJCusSetTinyPopView.m
//  mix
//
//  Created by yj on 2019/2/13.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJCusSetTinyPopView.h"

@interface JGJCusSetTinyPopView ()

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation JGJCusSetTinyPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setupView];
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        [self setupView];
        
    }
    return self;
}

-(void)setupView{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [window addSubview:self];
    
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    self.contentDetailView.backgroundColor = AppFontf1f1f1Color;
    
    self.money.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 9, 35)];
    
    self.money.leftViewMode = UITextFieldViewModeAlways;
    
    [self.money.layer setLayerBorderWithColor:AppFontdbdbdbColor width:1 radius:2];
    
    self.contentDetailView.backgroundColor = AppFontffffffColor;
    
    self.selCntsDes.textColor = AppFont000000Color;
    
    self.wageTitle.textColor = AppFont666666Color;
    
    self.des.textColor = AppFont666666Color;
    
    self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    
    [self.contentDetailView.layer setLayerCornerRadius:5];
    
    self.selCntsDes.font = [UIFont boldSystemFontOfSize:AppFont30Size];
    
    [self.leftBtn setTitleColor:AppFont333333Color forState:UIControlStateNormal];
}

- (IBAction)cancelBtnPresssed:(UIButton *)sender {
    
    if (self.cancelBlock) {
        
        self.cancelBlock(self);
    }
    
    [self dismissWithBlcok:nil];
}

- (IBAction)confirmBtnPressed:(UIButton *)sender {
    
    if (self.confirmBlock) {
        
        self.confirmBlock(self);
    }
    
    double salary = [self.money.text doubleValue];
    
    if ([NSString isFloatZero:salary] || [NSString isEmpty:self.money.text]) {
        
        return;
    }
    
    [self dismissWithBlcok:nil];
    
}

- (void)dismissWithBlcok:(void (^)(void))block {
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.contentView.alpha = 0;
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *hitView = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    
    if (hitView == self.contentView) {
        
        [self dismissWithBlcok:nil];
        
    }
}

@end

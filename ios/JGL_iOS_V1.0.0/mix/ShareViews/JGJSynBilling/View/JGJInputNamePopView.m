//
//  JGJInputNamePopView.m
//  mix
//
//  Created by yj on 2019/2/14.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJInputNamePopView.h"

@interface JGJInputNamePopView ()

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (weak, nonatomic) IBOutlet UIView *contentDetailView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation JGJInputNamePopView

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
    
    UIView *nameLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 35)];
    
    UIView *telLeftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7, 35)];

    self.name.leftView = nameLeftView;

    self.tel.leftView = telLeftView;

    self.name.leftViewMode = UITextFieldViewModeAlways;

    self.tel.leftViewMode = UITextFieldViewModeAlways;
    
    [self.name.layer setLayerBorderWithColor:AppFontdbdbdbColor width:1 radius:2];

    [self.tel.layer setLayerBorderWithColor:AppFontdbdbdbColor width:1 radius:2];

    self.contentDetailView.backgroundColor = AppFontffffffColor;

    self.contentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];

    [self.contentDetailView.layer setLayerCornerRadius:5];
    
    self.name.maxLength = UserNameLength;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.name];
    
    self.tel.textColor = AppFont666666Color;
    
    self.tel.userInteractionEnabled = NO;
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (IBAction)cancelBtnPresssed:(UIButton *)sender {
    
    if (self.cancelBlock) {
        
        self.cancelBlock();
    }
    
    [self dismissWithBlcok:nil];
}

- (IBAction)confirmBtnPressed:(UIButton *)sender {
    
    if ([NSString containsEmojiStr:self.name.text] || [NSString isEmpty:self.name.text]) {
        
        [TYShowMessage showPlaint:@"请输入正确姓名"];
        
        return;
    }
    
    if (self.confirmBlock) {
        
        self.confirmBlock(self);
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

- (void)setUserName:(NSString *)userName {
    
    _userName = userName;
    
}

- (void)setUserTel:(NSString *)userTel {
    
    _userTel = userTel;
    
//    self.tel.placeholder = userTel;
    
//    self.tel.userInteractionEnabled = NO;
    
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.name.maxLength];
    
}

@end

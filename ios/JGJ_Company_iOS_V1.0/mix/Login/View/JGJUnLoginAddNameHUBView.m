//
//  JGJAddNameHUBView.m
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJUnLoginAddNameHUBView.h"
#import "TYPredicate.h"
#import "TYShowMessage.h"
#import "NSString+Extend.h"

//static const CGFloat layerRation = 0.01;
@interface JGJUnLoginAddNameHUBView ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentDeatilView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentDetailLayoutC;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UILabel *nameTilteLable;

@end

@implementation JGJUnLoginAddNameHUBView

static JGJUnLoginAddNameHUBView *_jgjAddNameHUBView;

+ (JGJUnLoginAddNameHUBView *)hasRealNameByVc:(UIViewController <JGJUnLoginAddNameHUBViewDelegate>*)Vc{
    JGJUnLoginAddNameHUBView *jgjAddNameHUBView;
    if (!JLGIsRealNameBool) {
        jgjAddNameHUBView = [[JGJUnLoginAddNameHUBView alloc] initWithFrame:TYGetUIScreenRect];
        _jgjAddNameHUBView = jgjAddNameHUBView;
        [jgjAddNameHUBView showAddNameHubView];

        jgjAddNameHUBView.delegate = Vc;
    }else{
        jgjAddNameHUBView = nil;
    }
    
    return jgjAddNameHUBView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

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

+ (NSString *)handleSkipVc:(NSString *)currentVcStr {
    _jgjAddNameHUBView.currentVcStr = currentVcStr;
    return _jgjAddNameHUBView.currentVcStr;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    [self.contentDeatilView.layer setLayerCornerRadius:5.0];
    self.contentDeatilView.clipsToBounds = YES;

    [self.cancelButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
    
    [self.saveButton setTitleColor:AppFontEB4E4EColor forState:UIControlStateNormal];
    
    self.nameTilteLable.textColor = AppFontEB4E4EColor;
    
    self.titleLabel.text = @"进行下一步操作之前\n需要请你完善姓名";
    self.titleLabel.numberOfLines = 0;
    if (!self.nameTF.delegate) {
        self.nameTF.delegate = self;
    }
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.nameTF];
    
    self.nameTF.maxLength = UserNameLength;
    //不使用IQKeyborad的inputAccessoryView
    self.nameTF.inputAccessoryView = [[UIView alloc] init];
#if TYKeyboardObserver
        // 键盘的frame发生改变时发出的通知（位置和尺寸）
        [TYNotificationCenter addObserver:self selector:@selector(RPbaseInfoKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
#endif
}

#if TYKeyboardObserver
- (void)dealloc{
    [TYNotificationCenter removeObserver:self];
}
#endif

- (void)showAddNameHubView{
    self.nameTF.text = nil;
    self.frame = TYGetUIScreenRect;
    [self.nameTF becomeFirstResponder];
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self.contentView layoutIfNeeded];
    }
}

- (IBAction)hiddenAddNameHubView:(UIButton *)sender {
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self removeFromSuperview];
    }
    [self.nameTF resignFirstResponder];
    
}

- (IBAction)cancelBtnClick:(id)sender {
    [self hiddenAddNameHubView:nil];
    
    if (self.unLoginAddNameHUBViewBlock) {
        
        self.unLoginAddNameHUBViewBlock(self);
    }
    
}

- (IBAction)saveBtnClick:(id)sender {
    if ([NSString isEmpty:self.nameTF.text]) {
        [TYShowMessage showError:@"请输入姓名"];
        return;
    }

    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"jlsignup/upuserinfo" parameters:@{@"realname":self.nameTF.text} success:^(id responseObject) {
        [self hiddenAddNameHubView:nil];

        [TYUserDefaults setBool:YES forKey:JLGIsRealName];
        if (self.delegate && [self.delegate respondsToSelector:@selector(AddNameHubSaveSuccess:)]) {
            [self.delegate AddNameHubSaveSuccess:self];
        }
        
        if (![NSString isEmpty:self.nameTF.text]) {
            [TYUserDefaults setObject:self.nameTF.text?:@"" forKey:JGJUserName];
        }
        
        NSUInteger infoVer = [[TYUserDefaults objectForKey:JGJInfoVer] integerValue];
        infoVer += 1;
        [TYUserDefaults setObject:@(infoVer) forKey:JGJInfoVer];
     [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
         [TYLoadingHub hideLoadingView];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#if TYKeyboardObserver
#pragma mark - 监控键盘
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)RPbaseInfoKeyboardWillChangeFrame:(NSNotification *)notification
{
        NSDictionary *userInfo = notification.userInfo;
        // 动画的持续时间
        double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat distance =   endKeyboardRect.origin.y - TYGetMaxY(self.contentDeatilView) ;
        // 执行动画
        [UIView animateWithDuration:duration animations:^{
            if (distance < 40) {
                    self.contentDeatilView.transform = CGAffineTransformMakeTranslation(0, -40);
            } else {
                
                self.contentDeatilView.transform = CGAffineTransformIdentity;
            }
        }];
    }
}
#endif

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.nameTF.maxLength];
    
}

@end

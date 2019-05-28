//
//  YZGAddContactsHUBView.m
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGAddContactsHUBView.h"
#import "TYPredicate.h"
#import "TYShowMessage.h"
#import "YZGAddContactsTableViewCell.h"

static const CGFloat layerRation = 0.02;
@interface YZGAddContactsHUBView ()

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *topTipLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentDeatilView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentDetailLayoutC;

@end

@implementation YZGAddContactsHUBView

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

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    [self.contentDeatilView.layer setLayerBorderWithColor:TYColorHex(0xd4d4d4) width:0.5 ration:layerRation];
    self.contentDeatilView.clipsToBounds = YES;
    [self.nameView.layer setLayerBorderWithColor:TYColorHex(0xd4d4d4) width:0.5 ration:layerRation];
    [self.phoneView.layer setLayerBorderWithColor:TYColorHex(0xd4d4d4) width:0.5 ration:layerRation];
    self.saveButton.backgroundColor = JGJMainColor;
    [self.saveButton.layer setLayerCornerRadiusWithRatio:layerRation];

    self.topTipLabel.textColor = JGJMainColor;
    self.topTipLabel.text = @"能及时将你的记账信息与对方同步,\n 有利于对方更快与你在线对账，避免差异";
    if (!self.phoneNumTF.delegate) {
        self.phoneNumTF.delegate = self;
    }
    
    self.nameTF.inputAccessoryView = [[UIView alloc] init];
    self.phoneNumTF.inputAccessoryView = [[UIView alloc] init];
    
    self.nameTF.maxLength = UserNameLength;
    
    self.phoneNumTF.maxLength = 11;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.nameTF];

//#if TYKeyboardObserver
//    // 键盘的frame发生改变时发出的通知（位置和尺寸）
//    [TYNotificationCenter addObserver:self selector:@selector(AddContactsKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//#endif
}

//#if TYKeyboardObserver
//- (void)dealloc{
//    [TYNotificationCenter removeObserver:self];
//}
//
//#pragma mark - 监控键盘
///**
// * 键盘的frame发生改变时调用（显示、隐藏等）
// */
//- (void)AddContactsKeyboardWillChangeFrame:(NSNotification *)notification
//{
//    NSDictionary *userInfo = notification.userInfo;
//    // 动画的持续时间
//    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
//    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGRect beginKeyboardRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
//    CGFloat distance =  beginKeyboardRect.origin.y - endKeyboardRect.origin.y;
//    
//    // 执行动画
//    [UIView animateWithDuration:duration animations:^{
//        if (distance > 0) {
//            self.contentDeatilView.transform = CGAffineTransformMakeTranslation(0, -40);
//        } else {
//            self.contentDeatilView.transform = CGAffineTransformIdentity;
//        }
//    }];
//}
//#endif

- (void)YZGAddFmNoViewBtnClick:(YZGAddFmNoContactsView *)addFmNoContactsView{
    [self showAddContactsHubView];
}

- (void)showAddContactsHubView{
    self.nameTF.text = nil;
    self.phoneNumTF.text = nil;
    self.frame = TYGetUIScreenRect;
    [self.nameTF becomeFirstResponder];
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self.contentView layoutIfNeeded];
    }
}

- (IBAction)hiddenAddContactsHubView:(UIButton *)sender {
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self removeFromSuperview];
    }
    [self.nameTF resignFirstResponder];
    [self.phoneNumTF resignFirstResponder];
}

#pragma mark - textField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{  //string就是此时输入的那个字符textField就是此时正在输入的那个输入框返回YES就是可以改变输入框的值NO相反
    if ([string isEqualToString:@"\n"])  //按回车可以改变
    {
        return YES;
    }
      NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (textField.tag == 22) {//只能输入数字
        //只能输入数字
        unichar single= string.length >0?[string characterAtIndex:0]:'0';
        if (!((single >='0' && single<='9')))//数字不能输入
        {
            return NO;
        }
        
        if ([toBeString length] > 11) {
            textField.text = [toBeString substringToIndex:11];
            return NO;
        }
    }
    return YES;
}

- (IBAction)saveBtnClick:(id)sender {
    
    if ([NSString isEmpty:self.phoneNumTF.text]) {
        
        [TYShowMessage showPlaint:@"请输入手机号码"];
        
        return;
    }

    if (self.phoneNumTF.text.length != 11   ||  ! [TYPredicate isRightPhoneNumer:self.phoneNumTF.text]) {
        
        [TYShowMessage showPlaint:@"请输入正确的手机号码"];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/addfm" parameters:@{@"name":self.nameTF.text,@"telph":self.phoneNumTF.text} success:^(id responseObject) {
        [weakSelf hiddenAddContactsHubView:nil];
        
        YZGAddForemanModel *yzgAddForemanModel = [[YZGAddForemanModel alloc] init];
        [yzgAddForemanModel mj_setKeyValues:responseObject];
        weakSelf.yzgAddForemanModel = yzgAddForemanModel;
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(AddContactsHubSaveBtcClick:)]) {
            [weakSelf.delegate AddContactsHubSaveBtcClick:weakSelf];
        }
    }failure:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.nameTF.maxLength];
    
}
@end

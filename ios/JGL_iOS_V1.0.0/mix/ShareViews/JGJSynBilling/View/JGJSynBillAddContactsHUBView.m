//
//  JGJSynBillAddContactsHUBView.m
//  mix
//
//  Created by Tony on 16/3/12.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSynBillAddContactsHUBView.h"
#import "TYPredicate.h"
#import "TYShowMessage.h"
#import "NSString+Extend.h"

//static const CGFloat layerRation = 0.01;
typedef void(^HUBViewGetMemberRealNameBlock)(id);
@interface JGJSynBillAddContactsHUBView ()

@property (weak, nonatomic) IBOutlet UILabel *topTipLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentDeatilView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentDetailLayoutC;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *remarkTextFieldHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toptipLableHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containDetailViewHeight;
@property (copy, nonatomic) HUBViewGetMemberRealNameBlock hubViewGetMemberRealNameBlock;
@end

@implementation JGJSynBillAddContactsHUBView

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

- (void)setAddContactsHUBViewType:(AddContactsHUBViewType)addContactsHUBViewType {
    _addContactsHUBViewType = addContactsHUBViewType;
    if (_addContactsHUBViewType == AddProTeamContactsHUBViewType) {
        self.topTipLabel.text = nil;
        [self.saveButton setTitle:@"添加" forState:UIControlStateNormal];
        self.titleLabel.text = @"添加项目成员";
        self.remarkTextFieldHeight.constant = 0;
        self.toptipLableHeight.constant = 0;
        self.containDetailViewHeight.constant = 220;
    }
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    [self.contentDeatilView.layer setLayerCornerRadius:5.0];
    self.contentDeatilView.clipsToBounds = YES;
    self.saveButton.backgroundColor = JGJMainColor;

    self.topTipLabel.textColor = JGJMainColor;
    self.topTipLabel.text = @"同步账单成功后，\n对方能够随时查看账单的最新信息";
    if (!self.phoneNumTF.delegate) {
        self.phoneNumTF.delegate = self;
    }
    
    self.nameTF.maxLength = UserNameLength;
    self.phoneNumTF.maxLength = 11;
    self.descriptTF.maxLength = 8;
    __weak typeof(self) weakSelf = self;
    self.phoneNumTF.valueDidChange = ^(NSString *value){
        [weakSelf checkInputTelephone:value];
    };
    self.nameTF.inputAccessoryView = [[UIView alloc] init];
    self.phoneNumTF.inputAccessoryView = [[UIView alloc] init];
    self.descriptTF.inputAccessoryView = [[UIView alloc] init];
    
//#if TYKeyboardObserver
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [TYNotificationCenter addObserver:self selector:@selector(RPbaseInfoKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
//#endif
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:self.nameTF];
    
}

//#if TYKeyboardObserver
- (void)dealloc{
    [TYNotificationCenter removeObserver:self];
}

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
//#endif

- (void)showAddContactsHubView{
    self.nameTF.text = nil;
    self.phoneNumTF.text = nil;
    self.frame = TYGetUIScreenRect;
    [self.phoneNumTF becomeFirstResponder];
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
    // 判断是否输入数字进行判断
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

#pragma mark - 判断是否输入数字进行判断
- (void)checkInputTelephone:(NSString *)telephone {
    if ([NSString isInputNum:telephone] && telephone.length == 11) {
        [self getMemberRealName];
        __weak typeof(self) weakSelf = self;
        self.hubViewGetMemberRealNameBlock = ^(id responseObject){
            JGJSynBillingModel *memberModel = [JGJSynBillingModel mj_objectWithKeyValues:responseObject];
            if (![NSString isEmpty:memberModel.real_name] && [memberModel.real_name isKindOfClass:[NSString class]]) {
                weakSelf.nameTF.text = memberModel.real_name;
                
                weakSelf.head_pic = memberModel.head_pic;
                
            }else {
                weakSelf.nameTF.text = nil;
                weakSelf.nameTF.placeholder = @"请输入对方的姓名";
            }
        };
    }
}

- (IBAction)saveBtnClick:(id)sender {
    [self endEditing:YES];
    
    if ([NSString isEmpty:self.phoneNumTF.text]) {
        
        [TYShowMessage showPlaint:@"请输入手机号码"];
        
        return;
    }
    
    if (self.phoneNumTF.text.length != 11   ||  ! [TYPredicate isRightPhoneNumer:self.phoneNumTF.text]) {
        [TYShowMessage showPlaint:@"请输入正确的手机号码"];
        return;
    }
    if ([NSString isEmpty:self.nameTF.text]) {
        [TYShowMessage showPlaint:@"请输入对方的姓名"];
        return;
    }else if (self.nameTF.text.length < 2 || self.nameTF.text.length > 10) {
        
        [TYShowMessage showPlaint:@"姓名只能为二到十个字"];
        return;
    }
//    2.0添加班组成员
    if (_addContactsHUBViewType == AddProTeamContactsHUBViewType) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(SynBillAddContactsHubSaveSuccess:)]) {
            [self hiddenAddContactsHubView:nil];
            [self.delegate SynBillAddContactsHubSaveSuccess:self];
        }
        return;
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithApi:@"jlworksync/optusersync" parameters:@{@"realname":self.nameTF.text,@"telph":self.phoneNumTF.text,@"descript":self.descriptTF.text?:[NSNull null],@"option":@"a"} success:^(id responseObject) {
        [self hiddenAddContactsHubView:nil];

        self.jgjSynBillingModel.telephone = self.phoneNumTF.text;
        self.jgjSynBillingModel.real_name = self.nameTF.text;
        self.jgjSynBillingModel.descript = self.descriptTF.text;
        self.jgjSynBillingModel.target_uid = responseObject[@"target_uid"];
        if (self.delegate && [self.delegate respondsToSelector:@selector(SynBillAddContactsHubSaveSuccess:)]) {
            [self.delegate SynBillAddContactsHubSaveSuccess:self];
             [TYLoadingHub hideLoadingView];
        }
    }failure:nil];
}

#pragma mark - 获取成员在我们平台注册之后的姓名
- (void)getMemberRealName {
    NSDictionary *parameters = @{
                                 @"telephone" : self.phoneNumTF.text ?:@""
                                 };
    __weak typeof(self) weakSelf = self;

    [JLGHttpRequest_AFN PostWithNapi:@"user/useTelGetUserInfo" parameters:parameters success:^(id responseObject) {
        
        if (weakSelf.hubViewGetMemberRealNameBlock) {
            
            weakSelf.hubViewGetMemberRealNameBlock(responseObject);
            
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (JGJSynBillingModel *)jgjSynBillingModel
{
    if (!_jgjSynBillingModel) {
        _jgjSynBillingModel = [[JGJSynBillingModel alloc] init];
    }
    return _jgjSynBillingModel;
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.nameTF.maxLength];
    
}

@end

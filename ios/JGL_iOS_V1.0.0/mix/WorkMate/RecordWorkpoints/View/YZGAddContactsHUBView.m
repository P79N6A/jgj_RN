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
#import "TYPredicate.h"
#import "NSString+Extend.h"

#define WorkLeaderDes @"请输入班组长/工头的电话号码"

#define WorkerDes @"请输入工人的电话号码"

#define WorkLeaderNameDes @"请输入班组长/工头的姓名"

#define WorkNameDes @"请输入工人的姓名"

static const CGFloat layerRation = 0.02;
typedef void(^HUBViewGetMemberRealNameBlock)(id);
@interface YZGAddContactsHUBView ()

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UILabel *topTipLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentDeatilView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentDetailLayoutC;
@property (copy, nonatomic) HUBViewGetMemberRealNameBlock hubViewGetMemberRealNameBlock;
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
    [self.contentDeatilView.layer setLayerCornerRadius:5];
    self.contentDeatilView.clipsToBounds = YES;
    [self.nameView.layer setLayerBorderWithColor:TYColorHex(0xd4d4d4) width:0.5 ration:layerRation];
    [self.phoneView.layer setLayerBorderWithColor:TYColorHex(0xd4d4d4) width:0.5 ration:layerRation];
    self.saveButton.backgroundColor = JGJMainColor;
//    [self.saveButton.layer setLayerCornerRadiusWithRatio:layerRation];

    self.topTipLabel.textColor = JGJMainColor;
    
    self.topTipLabel.text = @"能及时将你的记账信息与对方同步,\n 有利于对方更快与你在线对账，避免差异";
    
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    
    if (!self.phoneNumTF.delegate) {
        self.phoneNumTF.delegate = self;
    }
    
    self.nameTF.inputAccessoryView = [[UIView alloc] init];
    self.phoneNumTF.inputAccessoryView = [[UIView alloc] init];
    self.nameTF.maxLength = UserNameLength;
    __weak typeof(self) weakSelf = self;
    self.nameTF.valueDidChange = ^(NSString *value){
        weakSelf.nameTF.text = [weakSelf.nameTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    };
    self.phoneNumTF.maxLength = 11;
    self.phoneNumTF.valueDidChange = ^(NSString *value){
        [weakSelf checkInputTelephone:value];
    };
    
    
    if (!JLGisLeaderBool) {
        
        self.phoneNumTF.placeholder = WorkLeaderDes;
        
        self.nameTF.placeholder = WorkLeaderNameDes;
        
        self.titleLabel.text = @"添加班组长/工头";
        
    }else {
    
        self.phoneNumTF.placeholder = WorkerDes;
        
        self.nameTF.placeholder = WorkNameDes;
        
        self.titleLabel.text = @"添加工人";
        
    }
    
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

- (void)setHubViewType:(YZGAddContactsHUBViewType)hubViewType {
    
    _hubViewType = hubViewType;
    
    if (self.hubViewType == YZGAddContactsHUBViewSynType) {
        
        self.topTipLabel.text = @"请填写同步对象的手机号及姓名";
        
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
        
        self.titleLabel.text = @"班组长/工头";
        
        self.phoneNumTF.placeholder = WorkLeaderDes;
        
        self.nameTF.placeholder = WorkLeaderNameDes;
        
    }else if (self.hubViewType == YZGAddContactsHUBViewSynToMeType) {
        
        self.topTipLabel.text = @"邀请班组长向你同步记工记账数据";
        
        [self.saveButton setTitle:@"发送邀请" forState:UIControlStateNormal];
        
        self.titleLabel.text = @"班组长/工头";
        
        self.phoneNumTF.placeholder = WorkLeaderDes;
        
        self.nameTF.placeholder = WorkLeaderNameDes;
    }
    
    else {
        
        self.topTipLabel.text = @"能及时将你的记账信息与对方同步,\n 有利于对方更快与你在线对账，避免差异";
        
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    }
    
}

- (void)YZGAddFmNoViewBtnClick:(YZGAddFmNoContactsView *)addFmNoContactsView{
    [self showAddContactsHubView];
}

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
    
    if ([NSString isEmpty:self.nameTF.text]) {
        
        [TYShowMessage showPlaint:@"请输入对方的姓名"];
        return;
        
    }else if (self.nameTF.text.length < 2) {
        
        [TYShowMessage showPlaint:@"名字只能为二至八个字！"];
        
        return;
    }
    
    //添加同步人员
    if (self.hubViewType == YZGAddContactsHUBViewSynType || self.hubViewType == YZGAddContactsHUBViewSynToMeType) {
        
        YZGAddForemanModel *memberModel = [YZGAddForemanModel new];
        
        memberModel.name = self.nameTF.text;
        
        memberModel.telph = self.phoneNumTF.text;
        
        self.yzgAddForemanModel = memberModel;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(AddContactsHubSaveBtcClick:)]) {
            
            [self.delegate AddContactsHubSaveBtcClick:self];
            
        }
        
        [self removeFromSuperview];
        
    }else {
        
        [self addMember];
    }

}

- (void)addMember {
    
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];
    
    NSDictionary *parameters = @{@"name":self.nameTF.text,
                                 @"telph":self.phoneNumTF.text};
    
    if (![NSString isEmpty:self.workProListModel.group_id]) {
        
        parameters = @{@"name":self.nameTF.text,
          
                       @"telph":self.phoneNumTF.text,
          
                       @"group_id" : self.workProListModel.group_id
          
          };
    }
    
    [JLGHttpRequest_AFN PostWithNapi:@"user/add-fm" parameters:parameters success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        [weakSelf hiddenAddContactsHubView:nil];
        
        YZGAddForemanModel *yzgAddForemanModel = [[YZGAddForemanModel alloc] init];
        [yzgAddForemanModel mj_setKeyValues:responseObject];
        weakSelf.yzgAddForemanModel = yzgAddForemanModel;
        
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(AddContactsHubSaveBtcClick:)]) {
            [weakSelf.delegate AddContactsHubSaveBtcClick:weakSelf];
        }
        
        [TYShowMessage showSuccess:@"添加成功！"];
        
    }failure:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
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

#pragma mark - 判断是否输入数字进行判断
- (void)checkInputTelephone:(NSString *)telephone {
    if ([NSString isInputNum:telephone] && telephone.length == 11) {
        
        [self getMemberRealName];
        
        __weak typeof(self) weakSelf = self;
        
        self.hubViewGetMemberRealNameBlock = ^(id responseObject){
            
            JGJSynBillingModel *memberModel = [JGJSynBillingModel mj_objectWithKeyValues:responseObject];
            
            if (![NSString isEmpty:memberModel.real_name] && [memberModel.real_name isKindOfClass:[NSString class]]) {
                
                weakSelf.nameTF.text = memberModel.real_name;
                
            }else {
                
                weakSelf.nameTF.text = nil;

                if (weakSelf.hubViewType == YZGAddContactsHUBViewSynType || weakSelf.hubViewType == YZGAddContactsHUBViewSynToMeType) {
                    
                    weakSelf.nameTF.placeholder = WorkLeaderNameDes;
                    
                }else {
                    
                    weakSelf.nameTF.placeholder = !JLGisLeaderBool ? WorkLeaderNameDes : WorkNameDes;
                }
                
            }
        };
    }
}

#pragma mark - 通知判断
-(void)textFiledEditChanged:(NSNotification*)obj {
    
    UITextField *textField = (UITextField *)obj.object;
    
    [NSString textEditChanged:textField maxLength:self.nameTF.maxLength];
    
}

@end

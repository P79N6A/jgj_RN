//
//  JLGAuthenticationViewController.m
//  mix
//
//  Created by Tony on 16/1/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGAuthenticationViewController.h"
#import "TYLoadingHub.h"
#import "CALayer+SetLayer.h"
#import "TYTextField.h"

@interface JLGAuthenticationViewController ()
{
    CGFloat _authenticationViewH;
    CGFloat _submitAuthenButtonH;
}
@property (weak, nonatomic) IBOutlet LengthLimitTextField *nameTF;

@property (weak, nonatomic) IBOutlet LengthLimitTextField *iconTF;
@property (nonatomic,strong) NSMutableDictionary *parametersDic;

@property (weak, nonatomic) IBOutlet UIView *promptView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//开始认证以后的状态
@property (weak, nonatomic) IBOutlet UIImageView *authentication_Rectangle_ImageView;
@property (weak, nonatomic) IBOutlet UILabel *authentication_Rectangle_Label;
@property (weak, nonatomic) IBOutlet UIButton *submitAuthenticationButton;

//constant
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *authenticationViewLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *submitAuthenButtonLayoutH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomH;
@end

@implementation JLGAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //记录原来的的高度
    _authenticationViewH = self.authenticationViewLayoutH.constant;
    _submitAuthenButtonH = self.submitAuthenButtonLayoutH.constant;
    
    self.authenticationViewLayoutH.constant = 0;//先隐藏
    self.parametersDic = [[NSMutableDictionary alloc] init];
    [self.submitAuthenticationButton.layer setLayerCornerRadius:4.0];
    self.submitAuthenticationButton.backgroundColor = JGJMainColor;
    [self.promptView.layer setLayerBorderWithColor:TYColorHex(0xdcdcdc) width:0.5 radius:4.0];
    self.promptView.clipsToBounds = YES;
    
#if TYKeyboardObserver
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [TYNotificationCenter addObserver:self selector:@selector(authenticationKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
#endif
    self.nameTF.maxLength = 8;
    self.iconTF.maxLength = 19;
    self.nameTF.font = [UIFont systemFontOfSize:AppFont30Size];
    self.iconTF.font = [UIFont systemFontOfSize:AppFont30Size];
}

#if TYKeyboardObserver
- (void)dealloc{
    [TYNotificationCenter removeObserver:self];
}

#pragma mark - 监控键盘
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)authenticationKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect beginKeyboardRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = beginKeyboardRect.origin.y - endKeyboardRect.origin.y;
    
    __weak typeof(self) weakSelf = self;
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        //显示
        weakSelf.scrollViewBottomH.constant += yOffset;
        [weakSelf.scrollView layoutIfNeeded];
    }];
}
#endif

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setAuthenticationStatus];
}

- (void)JLGHttpRequest{
    [TYLoadingHub showLoadingWithMessage:@""];
    __weak typeof(self) weakSelf = self;

    [JLGHttpRequest_AFN PostWithApi:@"jlsignup/idAuth" parameters:self.parametersDic success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        weakSelf.responseObject = [responseObject mutableCopy];
        [weakSelf setAuthenticationStatus];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)setAuthenticationStatus{
    NSInteger verified = [self.responseObject[@"verified"] integerValue];
    self.nameTF.text = self.responseObject[@"realname"]?:self.nameTF.text;
    self.iconTF.text = self.responseObject[@"icno"]?:self.iconTF.text;
    if(verified == 0){//获取信息
        self.authenticationViewLayoutH.constant = 0;
    }else{
        [self setAuthenticationView:verified];
    }
}

- (IBAction)submitAuthenticationBtnClick:(UIButton *)sender {
    self.parametersDic[@"realname"] = self.nameTF.text;
    self.parametersDic[@"icno"] = self.iconTF.text;
    
    [self.nameTF resignFirstResponder];
    [self.iconTF resignFirstResponder];
    [self JLGHttpRequest];
}

- (void)setAuthenticationView:(NSInteger )verified{
    self.authenticationViewLayoutH.constant = _authenticationViewH;
    self.authentication_Rectangle_ImageView.hidden = NO;
    
    NSString *contentString;
    NSString *firstString;
    NSString *secondString;
    if(verified == -1){//认证失败
        self.authentication_Rectangle_ImageView.image = [UIImage imageNamed:@"authentication_Fail"];
        self.authentication_Rectangle_Label.textColor = [UIColor whiteColor];
        firstString = @"真实姓名和身份证号码不一致";
        secondString = @"无此身份证号码";
        self.submitAuthenButtonLayoutH.constant = _submitAuthenButtonH;
        [self.submitAuthenticationButton setTitle:@"重新提交认证" forState:UIControlStateNormal];
    }else if(verified == 1){//认证中
        self.submitAuthenButtonLayoutH.constant = 0;
        firstString = @"信息正在认证中";
        secondString = @"需要1~2个工作日";
        self.authentication_Rectangle_Label.textColor = TYColorHex(0x5f5f5f);
        self.authentication_Rectangle_ImageView.image = [UIImage imageNamed:@"authentication_ing"];
    }else if(verified == 2){//认证成功
        self.submitAuthenButtonLayoutH.constant = 0;
        firstString = @"恭喜你已通过实名认证";
        secondString = @"赶紧去找工作/找活干吧";
        self.authentication_Rectangle_Label.textColor = [UIColor whiteColor];
        self.authentication_Rectangle_ImageView.image = [UIImage imageNamed:@"authentication_Success"];
        self.promptView.hidden = YES;
        self.nameTF.userInteractionEnabled = NO;
        self.iconTF.userInteractionEnabled = NO;
    }
    
    contentString = [NSString stringWithFormat:@"%@\n%@",firstString,secondString];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:contentString];
    //设置间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:6];//调整行间距
    
    [contentStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentString.length)];
    [contentStr addAttribute:NSForegroundColorAttributeName value:JGJMainColor range:NSMakeRange(0, contentStr.length)];
    [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f] range:NSMakeRange(0, contentString.length)];
    
    if (verified == 1 || verified == 2) {
        [contentStr addAttribute:NSForegroundColorAttributeName value:AppFont666666Color range:NSMakeRange(firstString.length + 1, secondString.length)];
        [contentStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:NSMakeRange(firstString.length + 1, secondString.length)];
    }
    
    self.authentication_Rectangle_Label.attributedText = contentStr;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)responseObject{
    if (!_responseObject) {
        _responseObject = [NSMutableDictionary dictionary];
    }
    return _responseObject;
}

@end

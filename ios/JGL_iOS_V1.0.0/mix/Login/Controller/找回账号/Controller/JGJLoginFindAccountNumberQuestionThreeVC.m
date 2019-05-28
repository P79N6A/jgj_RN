//
//  JGJLoginFindAccountNumberQuestionThreeVC.m
//  mix
//
//  Created by Tony on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLoginFindAccountNumberQuestionThreeVC.h"
#import "JGJLoginFindAccountTestAndVerifyVC.h"
#import "JGJQuestionTitleView.h"
#import "JGJFindAccountNumberNextBtnView.h"
#import "JGJOriginalPhoneNumberTopView.h"
#import "CustomAlertView.h"
#import "JGJCustomPopView.h"
#import "JGJmodifiPhoneViewController.h"
#import "JGJLoginFindAccountNumberIsCertificationVC.h"
#import "SJButton.h"
@interface JGJLoginFindAccountNumberQuestionThreeVC ()
{
    NSInteger _selectedIndex;
}
@property (nonatomic, strong) JGJOriginalPhoneNumberTopView *originalPhoneNumberTopView;
@property (nonatomic, strong) JGJQuestionTitleView *questionTitleView;
@property (nonatomic, strong) JGJFindAccountNumberNextBtnView *nextStepBtnView;

@property (nonatomic, strong) UIScrollView *questionScroll;
@property (nonatomic, strong) UIButton *questionOneBtn;// 第一个问题
@property (nonatomic, strong) UIButton *questionTwoBtn;// 第二个问题
@property (nonatomic, strong) UIButton *questionThreeBtn;// 第三个问题
@property (nonatomic, strong) UIButton *questionFourBtn;// 第四个问题

@property (nonatomic, strong) NSMutableArray *btnArr;

@property (nonatomic, strong) SJButton *refreshBtn;// 换一组

@end

@implementation JGJLoginFindAccountNumberQuestionThreeVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"找回账号";
    self.navigationController.navigationBar.barTintColor = AppFontfafafaColor;
    self.view.backgroundColor = AppFontffffffColor;
    [self initializeAppearance];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.questionScroll];
    
    [self.questionScroll addSubview:self.originalPhoneNumberTopView];
    [self.questionScroll addSubview:self.questionTitleView];
    
    [self.questionScroll addSubview:self.questionOneBtn];
    [self.questionScroll addSubview:self.questionTwoBtn];
    [self.questionScroll addSubview:self.questionThreeBtn];
    [self.questionScroll addSubview:self.questionFourBtn];
    [self.questionScroll addSubview:self.refreshBtn];
    
    [self.view addSubview:self.nextStepBtnView];
    [self setUpLayout];
    
    [_questionOneBtn updateLayout];
    [_questionTwoBtn updateLayout];
    [_questionThreeBtn updateLayout];
    [_questionFourBtn updateLayout];
    
    _questionOneBtn.layer.cornerRadius = 5;
    _questionTwoBtn.layer.cornerRadius = 5;
    _questionThreeBtn.layer.cornerRadius = 5;
    _questionFourBtn.layer.cornerRadius = 5;
    _refreshBtn.layer.cornerRadius = 15;
    _questionScroll.contentSize = CGSizeMake(TYGetUIScreenWidth - 120, CGRectGetMaxY(_refreshBtn.frame) + 40);
    
    __weak typeof(self) weakSelf = self;
    __strong typeof(self) strongSelf = self;
    _nextStepBtnView.nextStep = ^{
        
        if (strongSelf -> _selectedIndex == 0) {
            
            [TYShowMessage showPlaint:@"请选择答案"];
            return;
        }
        // 没有选择记工,直接验证
        if (!weakSelf.isHavChoiceRecordWorkpoints) {
            
            CustomAlertView *alert = [CustomAlertView showWithMessage:nil leftButtonTitle:nil midButtonTitle:nil rightButtonTitle:nil];
            
            [alert showProgressImageView:@"正在验证..."];
            AnswerListModel *model = weakSelf.answerModel.answer_list[strongSelf -> _selectedIndex - 1];
            NSDictionary *param = @{@"telephone":weakSelf.phoneNumberStr,
                                    @"cid":model.cid,
                                    @"token":weakSelf.answerModel.token
                                    };
            [JLGHttpRequest_AFN PostWithApi:@"v2/signup/findaccountcheck" parameters:param success:^(id responseObject) {
                
                NSLog(@"responseObject = %@",responseObject);
                __block NSDictionary *dic = (NSDictionary *)responseObject;
                [alert dismissWithBlcok:^{
                    
                    if ([dic[@"is_pass"] integerValue] == 0) {
                        
                        [weakSelf verifyFailed];
                        
                    }else {
                        
                        JGJmodifiPhoneViewController *modifyPhoneVC = [[UIStoryboard storyboardWithName:@"modifyphone" bundle:nil] instantiateViewControllerWithIdentifier:@"modifiPhoneVc"];
                        [modifyPhoneVC setIsFindAccoutInWithToken:YES token:weakSelf.answerModel.token];
                        [weakSelf.navigationController pushViewController:modifyPhoneVC animated:YES];
                        
                    }
                }];
                
            } failure:^(NSError *error) {
                
                [alert dismissWithBlcok:^{
                    
                    [weakSelf verifyFailed];
                }];
            }];
        }else {
            
            NSString *answer = [[NSString alloc] init];
            AnswerListModel *model = weakSelf.answerModel.answer_list[strongSelf -> _selectedIndex - 1];
            answer = model.options;
            JGJLoginFindAccountTestAndVerifyVC *vc = [[JGJLoginFindAccountTestAndVerifyVC alloc] init];
            vc.phoneNumberStr = weakSelf.phoneNumberStr;
            vc.answerString = answer;
            vc.token = weakSelf.answerModel.token;
            vc.cid = model.cid;
            
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        
    };
}

- (void)verifyFailed {
    
    JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
    
    desModel.title = @"验证失败";
    
    desModel.popDetail = @"如有疑问，请联系吉工家客服!";
    
    desModel.leftTilte = @"重新验证";
    
    desModel.rightTilte = @"联系客服";
    
    JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
    alertView.isNotTouchViewHide = YES;
    alertView.TitleLable.textColor = AppFont000000Color;
    alertView.TitleLable.font = [UIFont boldSystemFontOfSize:AppFont36Size];
    
    alertView.messageLable.textInsets = UIEdgeInsetsMake(-30, 0, 0, 0);
    alertView.messageLable.font = FONT(AppFont30Size);
    alertView.messageLable.textColor = AppFont666666Color;
    
    alertView.titleLableTop.constant = 45;
    alertView.messageLabelTop.constant = 0;
    __weak typeof(self) weakSelf = self;
    alertView.leftButtonBlock = ^{
        
        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[JGJLoginFindAccountNumberIsCertificationVC class]]) {
                
                [weakSelf.navigationController popToViewController:vc animated:YES];
            }
        }
        
    };
    
    alertView.onOkBlock = ^{
        
        NSString * str = [NSString stringWithFormat:@"tel:%@",@"4008623818"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    };
}

- (void)refreshNewQuestions {
 
    NSDictionary *params = @{@"token":self.answerModel.token};
    [JLGHttpRequest_AFN PostWithApi:@"v2/signup/refreshfindaccountques" parameters:params success:^(id responseObject) {
        
        JGJLoginFindAccountAnswerModel *answerModel = [JGJLoginFindAccountAnswerModel mj_objectWithKeyValues:responseObject];
        [self setAnswerModel:answerModel];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setIsHavChoiceRecordWorkpoints:(BOOL)isHavChoiceRecordWorkpoints {
    
    _isHavChoiceRecordWorkpoints = isHavChoiceRecordWorkpoints;
    self.nextStepBtnView.isHavChoiceRecordWorkpoints = _isHavChoiceRecordWorkpoints;
}

- (void)setAnswerModel:(JGJLoginFindAccountAnswerModel *)answerModel {
    
    _answerModel = answerModel;
    
    self.questionTitleView.questionTitleStr = [NSString stringWithFormat:@"%@",_answerModel.ques_title];
    AnswerListModel *one = _answerModel.answer_list[0];
    AnswerListModel *two = _answerModel.answer_list[1];
    AnswerListModel *three = _answerModel.answer_list[2];
    AnswerListModel *four = _answerModel.answer_list[3];
    [self.questionOneBtn setTitle:one.options forState:(UIControlStateNormal)];
    [self.questionTwoBtn setTitle:two.options forState:(UIControlStateNormal)];
    [self.questionThreeBtn setTitle:three.options forState:(UIControlStateNormal)];
    [self.questionFourBtn setTitle:four.options forState:(UIControlStateNormal)];
    
}

- (void)setUpLayout {
    
    _nextStepBtnView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, JGJ_IphoneX_BarHeight).heightIs(60);
    
    _questionScroll.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(_nextStepBtnView, 0);
    
    _originalPhoneNumberTopView.sd_layout.leftSpaceToView(_questionScroll, 0).topSpaceToView(_questionScroll, 0).rightSpaceToView(_questionScroll, 0).heightIs(80);
    _questionTitleView.sd_layout.leftSpaceToView(_questionScroll, 0).topSpaceToView(_originalPhoneNumberTopView, 0).rightSpaceToView(_questionScroll, 0).heightIs(130);
    
    _questionOneBtn.sd_layout.leftSpaceToView(_questionScroll, 60).topSpaceToView(_questionTitleView, 20).rightSpaceToView(_questionScroll, 60).heightIs(44);
    _questionTwoBtn.sd_layout.leftEqualToView(_questionOneBtn).topSpaceToView(_questionOneBtn, 20).rightEqualToView(_questionOneBtn).heightIs(44);
    _questionThreeBtn.sd_layout.leftEqualToView(_questionTwoBtn).topSpaceToView(_questionTwoBtn, 20).rightEqualToView(_questionTwoBtn).heightIs(44);
    _questionFourBtn.sd_layout.leftEqualToView(_questionThreeBtn).topSpaceToView(_questionThreeBtn, 20).rightEqualToView(_questionThreeBtn).heightIs(44);
    _refreshBtn.sd_layout.centerXEqualToView(_questionScroll).topSpaceToView(_questionFourBtn, 35).heightIs(30).widthIs(90);
}

- (void)setPhoneNumberStr:(NSString *)phoneNumberStr {
    
    _phoneNumberStr = phoneNumberStr;
    self.originalPhoneNumberTopView.phoeNumberStr = _phoneNumberStr;
    
}

- (void)btnClick:(UIButton *)sender {
    
    _selectedIndex = sender.tag - 100;
    if (!sender.selected) {
     
        sender.selected = YES;
        sender.layer.borderColor = AppFontEB4E4EColor.CGColor;
    }
    
    for (int i = 0; i < self.btnArr.count; i ++) {
        
        UIButton *btn = self.btnArr[i];
        
        if (btn.tag != sender.tag) {
            
            btn.selected = NO;
            btn.layer.borderColor = AppFontdbdbdbColor.CGColor;
        }
    }
}

#pragma mark - getter/setter
- (JGJOriginalPhoneNumberTopView *)originalPhoneNumberTopView {
    
    if (!_originalPhoneNumberTopView) {
        
        _originalPhoneNumberTopView = [[JGJOriginalPhoneNumberTopView alloc] init];
    }
    return _originalPhoneNumberTopView;
}

- (JGJQuestionTitleView *)questionTitleView {
    
    if (!_questionTitleView) {
        
        _questionTitleView = [[JGJQuestionTitleView alloc] init];
        
    }
    return _questionTitleView;
}

- (JGJFindAccountNumberNextBtnView *)nextStepBtnView {
    
    if (!_nextStepBtnView) {
        
        _nextStepBtnView = [[JGJFindAccountNumberNextBtnView alloc] init];
    }
    return _nextStepBtnView;
}

- (NSMutableArray *)btnArr {
    
    if (!_btnArr) {
        
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
}

- (UIScrollView *)questionScroll {
    
    if (!_questionScroll) {
        
        _questionScroll = [[UIScrollView alloc] init];
        _questionScroll.showsVerticalScrollIndicator = NO;
        _questionScroll.showsHorizontalScrollIndicator = NO;
        _questionScroll.backgroundColor = AppFontffffffColor;
    }
    return _questionScroll;
}
- (UIButton *)questionOneBtn {
    
    if (!_questionOneBtn) {
        
        _questionOneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _questionOneBtn.backgroundColor = AppFontffffffColor;
        [_questionOneBtn setImage:IMAGE(@"certificationNonChoiced") forState:(UIControlStateNormal)];
        [_questionOneBtn setImage:IMAGE(@"certificationChoiced") forState:(UIControlStateSelected)];
        _questionOneBtn.titleLabel.font = FONT(AppFont30Size);
        [_questionOneBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        [_questionOneBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateSelected)];
        _questionOneBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _questionOneBtn.tag = 101;
        _questionOneBtn.layer.borderWidth = 1;
        _questionOneBtn.layer.borderColor = AppFontdbdbdbColor.CGColor;
        [_questionOneBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnArr addObject:_questionOneBtn];
    }
    return _questionOneBtn;
}

- (UIButton *)questionTwoBtn {
    
    if (!_questionTwoBtn) {
        
        _questionTwoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _questionTwoBtn.backgroundColor = AppFontffffffColor;
        [_questionTwoBtn setImage:IMAGE(@"certificationNonChoiced") forState:(UIControlStateNormal)];
        [_questionTwoBtn setImage:IMAGE(@"certificationChoiced") forState:(UIControlStateSelected)];
        _questionTwoBtn.titleLabel.font = FONT(AppFont30Size);
        [_questionTwoBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        [_questionTwoBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateSelected)];
        _questionTwoBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _questionTwoBtn.tag = 102;
        _questionTwoBtn.layer.borderWidth = 1;
        _questionTwoBtn.layer.borderColor = AppFontdbdbdbColor.CGColor;
        [_questionTwoBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnArr addObject:_questionTwoBtn];
    }
    return _questionTwoBtn;
}

- (UIButton *)questionThreeBtn {
    
    if (!_questionThreeBtn) {
        
        _questionThreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _questionThreeBtn.backgroundColor = AppFontffffffColor;
        [_questionThreeBtn setImage:IMAGE(@"certificationNonChoiced") forState:(UIControlStateNormal)];
        [_questionThreeBtn setImage:IMAGE(@"certificationChoiced") forState:(UIControlStateSelected)];
        _questionThreeBtn.titleLabel.font = FONT(AppFont30Size);
        [_questionThreeBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        [_questionThreeBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateSelected)];
        _questionThreeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _questionThreeBtn.tag = 103;
        _questionThreeBtn.layer.borderWidth = 1;
        _questionThreeBtn.layer.borderColor = AppFontdbdbdbColor.CGColor;
        [_questionThreeBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnArr addObject:_questionThreeBtn];
    }
    return _questionThreeBtn;
}

- (UIButton *)questionFourBtn {
    
    if (!_questionFourBtn) {
        
        _questionFourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _questionFourBtn.backgroundColor = AppFontffffffColor;
        [_questionFourBtn setImage:IMAGE(@"certificationNonChoiced") forState:(UIControlStateNormal)];
        [_questionFourBtn setImage:IMAGE(@"certificationChoiced") forState:(UIControlStateSelected)];
        _questionFourBtn.titleLabel.font = FONT(AppFont30Size);
        [_questionFourBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        [_questionFourBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateSelected)];
        _questionFourBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _questionFourBtn.tag = 104;
        _questionFourBtn.layer.borderWidth = 1;
        _questionFourBtn.layer.borderColor = AppFontdbdbdbColor.CGColor;
        [_questionFourBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnArr addObject:_questionFourBtn];
    }
    return _questionFourBtn;
}

- (SJButton *)refreshBtn {
    
    if (!_refreshBtn) {
        
        _refreshBtn = [SJButton buttonWithType:SJButtonTypeHorizontalImageTitle];
        [_refreshBtn setImage:IMAGE(@"refreshQuestion") forState:(SJControlStateNormal)];
        [_refreshBtn setTitle:@"换一组" forState:SJControlStateNormal];
        [_refreshBtn setTitleColor:AppFont000000Color forState:(SJControlStateNormal)];
        _refreshBtn.titleLabel.font = FONT(AppFont24Size);
        _refreshBtn.layer.borderColor = AppFont666666Color.CGColor;
        _refreshBtn.layer.borderWidth = 1;
        [_refreshBtn addTarget:self action:@selector(refreshNewQuestions) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _refreshBtn;
}
@end

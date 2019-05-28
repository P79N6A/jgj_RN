//
//  JGJLoginFindAccountNumberQuestionTwoVC.m
//  mix
//
//  Created by Tony on 2018/6/6.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLoginFindAccountNumberQuestionTwoVC.h"
#import "JGJQuestionTitleView.h"
#import "JGJFindAccountNumberNextBtnView.h"
#import "JGJOriginalPhoneNumberTopView.h"
#import "JGJLoginFindAccountNumberQuestionThreeVC.h"
#import "JGJLoginFindAccountAnswerModel.h"
@interface JGJLoginFindAccountNumberQuestionTwoVC ()

@property (nonatomic, strong) JGJOriginalPhoneNumberTopView *originalPhoneNumberTopView;
@property (nonatomic, strong) JGJQuestionTitleView *questionTitleView;
@property (nonatomic, strong) JGJFindAccountNumberNextBtnView *nextStepBtnView;

@property (nonatomic, strong) UIButton *recordWorkpointsBtn;// 记工按钮
@property (nonatomic, strong) UIButton *lookForWorkBtn;// 找活
@property (nonatomic, strong) UIButton *employWorkpointsBtn;// 招工

@property (nonatomic, strong) NSMutableArray *answerArr;
@property (nonatomic, strong) JGJLoginFindAccountAnswerModel *answerModel;

@end

@implementation JGJLoginFindAccountNumberQuestionTwoVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"找回账号";
    self.navigationController.navigationBar.barTintColor = AppFontfafafaColor;
    self.view.backgroundColor = AppFontffffffColor;
    [self initializeAppearance];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.originalPhoneNumberTopView];
    [self.view addSubview:self.questionTitleView];
    [self.view addSubview:self.recordWorkpointsBtn];
    [self.view addSubview:self.lookForWorkBtn];
    [self.view addSubview:self.employWorkpointsBtn];
    [self.view addSubview:self.nextStepBtnView];
    
    [self setUpLayout];
    [_recordWorkpointsBtn updateLayout];
    [_lookForWorkBtn updateLayout];
    [_employWorkpointsBtn updateLayout];
    
    _recordWorkpointsBtn.layer.cornerRadius = 5;
    _lookForWorkBtn.layer.cornerRadius = 5;
    _employWorkpointsBtn.layer.cornerRadius = 5;
    
    __weak typeof(self) weakSelf = self;
    _nextStepBtnView.nextStep = ^{
        
        if (weakSelf.answerArr.count == 0) {
            
            [TYShowMessage showPlaint:@"请选择答案"];
            return ;
        }
        JGJLoginFindAccountNumberQuestionThreeVC *vc = [[JGJLoginFindAccountNumberQuestionThreeVC alloc] init];
        vc.phoneNumberStr = weakSelf.phoneNumberStr;
        [TYLoadingHub showLoadingWithMessage:@"请稍候..."];
        NSDictionary *param = @{@"telephone":weakSelf.phoneNumberStr,
                                @"idcard":weakSelf.idCardStr,
                                @"type":[weakSelf.answerArr componentsJoinedByString:@","]
                                };
        [JLGHttpRequest_AFN PostWithApi:@"v2/signup/findaccount" parameters:param success:^(id responseObject) {

            [TYLoadingHub hideLoadingView];
            
            weakSelf.answerModel = [JGJLoginFindAccountAnswerModel mj_objectWithKeyValues:responseObject];
            vc.answerModel = weakSelf.answerModel;
            // 是否选择了记工
            if ([weakSelf.answerArr containsObject:@1]) {
                
                vc.isHavChoiceRecordWorkpoints = YES;
            }else {
                
                vc.isHavChoiceRecordWorkpoints = NO;
            }
            [weakSelf.navigationController pushViewController:vc animated:YES];

        } failure:^(NSError *error) {

             [TYLoadingHub hideLoadingView];
        }];
        
    };
}


- (void)setUpLayout {
    
    _originalPhoneNumberTopView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).heightIs(80);
    _questionTitleView.sd_layout.leftSpaceToView(self.view, 0).topSpaceToView(_originalPhoneNumberTopView, 0).rightSpaceToView(self.view, 0).heightIs(130);
    _recordWorkpointsBtn.sd_layout.leftSpaceToView(self.view, 60).topSpaceToView(_questionTitleView, 20).rightSpaceToView(self.view, 60).heightIs(44);
    _lookForWorkBtn.sd_layout.leftEqualToView(_recordWorkpointsBtn).topSpaceToView(_recordWorkpointsBtn, 20).rightEqualToView(_recordWorkpointsBtn).heightIs(44);
    _employWorkpointsBtn.sd_layout.leftEqualToView(_lookForWorkBtn).topSpaceToView(_lookForWorkBtn, 20).rightEqualToView(_lookForWorkBtn).heightIs(44);
    _nextStepBtnView.sd_layout.leftSpaceToView(self.view, 0).rightSpaceToView(self.view, 0).bottomSpaceToView(self.view, JGJ_IphoneX_BarHeight).heightIs(60);
}

- (void)setIdCardStr:(NSString *)idCardStr {
    
    _idCardStr = idCardStr;
}

- (void)setPhoneNumberStr:(NSString *)phoneNumberStr {
    
    _phoneNumberStr = phoneNumberStr;
    self.originalPhoneNumberTopView.phoeNumberStr = _phoneNumberStr;
}

- (void)btnClick:(UIButton *)sender {
    
    if (sender.selected) {
        
        sender.selected = NO;
        sender.layer.borderColor = AppFontdbdbdbColor.CGColor;
        
        if (sender.tag == 100) {
            
            [self.answerArr removeObject:@1];
            
        }else if (sender.tag == 101) {
            
            [self.answerArr removeObject:@2];
        }else {
            
            [self.answerArr removeObject:@3];
        }
        
    }else {
        
        sender.selected = YES;
        sender.layer.borderColor = AppFontEB4E4EColor.CGColor;
        
        if (sender.tag == 100) {
            
            [self.answerArr addObject:@1];
            
        }else if (sender.tag == 101) {
            
            [self.answerArr addObject:@2];
        }else {
            
            [self.answerArr addObject:@3];
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
        _questionTitleView.questionTitleStr = @"2.你曾经使用过平台的那些功能?(可多选)";
    }
    return _questionTitleView;
}

- (JGJFindAccountNumberNextBtnView *)nextStepBtnView {
    
    if (!_nextStepBtnView) {
        
        _nextStepBtnView = [[JGJFindAccountNumberNextBtnView alloc] init];
    }
    return _nextStepBtnView;
}

- (UIButton *)recordWorkpointsBtn {
    
    if (!_recordWorkpointsBtn) {
        
        _recordWorkpointsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _recordWorkpointsBtn.backgroundColor = AppFontffffffColor;
        [_recordWorkpointsBtn setImage:IMAGE(@"certificationNonChoiced") forState:(UIControlStateNormal)];
        [_recordWorkpointsBtn setImage:IMAGE(@"certificationChoiced") forState:(UIControlStateSelected)];
        [_recordWorkpointsBtn setTitle:@"记工" forState:(UIControlStateNormal)];
        _recordWorkpointsBtn.titleLabel.font = FONT(AppFont30Size);
        [_recordWorkpointsBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        [_recordWorkpointsBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateSelected)];
        _recordWorkpointsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _recordWorkpointsBtn.tag = 100;
        _recordWorkpointsBtn.layer.borderWidth = 1;
        _recordWorkpointsBtn.layer.borderColor = AppFontdbdbdbColor.CGColor;
        [_recordWorkpointsBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _recordWorkpointsBtn;
}

- (UIButton *)lookForWorkBtn {
    
    if (!_lookForWorkBtn) {
        
        _lookForWorkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _lookForWorkBtn.backgroundColor = AppFontffffffColor;
        [_lookForWorkBtn setImage:IMAGE(@"certificationNonChoiced") forState:(UIControlStateNormal)];
        [_lookForWorkBtn setImage:IMAGE(@"certificationChoiced") forState:(UIControlStateSelected)];
        [_lookForWorkBtn setTitle:@"找活" forState:(UIControlStateNormal)];
        _lookForWorkBtn.titleLabel.font = FONT(AppFont30Size);
        [_lookForWorkBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        [_lookForWorkBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateSelected)];
        _lookForWorkBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _lookForWorkBtn.tag = 101;
        _lookForWorkBtn.layer.borderWidth = 1;
        _lookForWorkBtn.layer.borderColor = AppFontdbdbdbColor.CGColor;
        [_lookForWorkBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _lookForWorkBtn;
}

- (UIButton *)employWorkpointsBtn {
    
    if (!_employWorkpointsBtn) {
        
        _employWorkpointsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _employWorkpointsBtn.backgroundColor = AppFontffffffColor;
        [_employWorkpointsBtn setImage:IMAGE(@"certificationNonChoiced") forState:(UIControlStateNormal)];
        [_employWorkpointsBtn setImage:IMAGE(@"certificationChoiced") forState:(UIControlStateSelected)];
        [_employWorkpointsBtn setTitle:@"招工" forState:(UIControlStateNormal)];
        _employWorkpointsBtn.titleLabel.font = FONT(AppFont30Size);
        [_employWorkpointsBtn setTitleColor:AppFont000000Color forState:(UIControlStateNormal)];
        [_employWorkpointsBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateSelected)];
        _employWorkpointsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        _employWorkpointsBtn.tag = 102;
        _employWorkpointsBtn.layer.borderWidth = 1;
        _employWorkpointsBtn.layer.borderColor = AppFontdbdbdbColor.CGColor;
        [_employWorkpointsBtn addTarget:self action:@selector(btnClick:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _employWorkpointsBtn;
}

- (NSMutableArray *)answerArr {
    
    if (!_answerArr) {
        
        _answerArr = [[NSMutableArray alloc] init];
    }
    return _answerArr;
}
@end

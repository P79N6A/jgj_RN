//
//  JGJRecordWorkpointsSettingController.m
//  mix
//
//  Created by Tony on 2019/2/16.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJRecordWorkpointsSettingController.h"
#import "JGJAccountShowTypeVc.h"
#import "JGJCustomPopView.h"
#import "JGJPeopleIsOpenReconciliationFunctionViewController.h"
#import "SJButton.h"

@interface JGJRecordWorkpointsSettingController ()

@property (nonatomic, strong) UIView *topInfoBackView;
@property (nonatomic, strong) UIView *infoBackTopLine;
@property (nonatomic, strong) UILabel *needReconciliationLabel;
@property (nonatomic, strong) UISwitch *reconciliationSwitch;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *reconciliationExplainOne;
@property (nonatomic, strong) UILabel *reconciliationExplainTwo;
@property (nonatomic, strong) SJButton *reconciliationExplainBtn;
@property (nonatomic, strong) UIButton *reconciliationExplainAllClickBtn;// 造成一种整行点击效果的假象

@property (nonatomic, strong) UIImageView *reconciliationExplainRightImage;

@property (nonatomic, strong) UIView *infoBackBottomLine;

@property (nonatomic, strong) UIView *showWayView;
@property (nonatomic, strong) UIView *showWayTopLine;
@property (nonatomic, strong) UILabel *showWayLabel;
@property (nonatomic, strong) UILabel *showWayInfo;
@property (nonatomic, strong) UIImageView *rightArrowImage;
@property (nonatomic, strong) UIView *showWayBottomLine;

@property (nonatomic, strong) JGJAccountShowTypeModel *selTypeModel;

@end

@implementation JGJRecordWorkpointsSettingController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.title = @"记工设置";
    
    [self initializeAppearance];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.selTypeModel = [JGJAccountShowTypeTool showTypeModel];
    
    //0.上班按工天、加班按小时 1.按工天, 2. 按小时
    if (self.selTypeModel.type == 0) {
        
        _showWayInfo.text = @"上班按工天，加班按小时";
        
    }else if (self.selTypeModel.type == 1) {
        
        _showWayInfo.text = @"上班、加班按工天";
        
    }else {
        
        _showWayInfo.text = @"上班、加班按小时";
        
    }
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/get-record-confirm-off-status" parameters:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        self.reconciliationSwitch.on = ![responseObject[@"status"] integerValue];
        
        if (self.reconciliationSwitch.on) {
            
            _reconciliationExplainTwo.hidden = NO;
            _reconciliationExplainBtn.hidden = NO;
            _reconciliationExplainAllClickBtn.hidden = NO;
            _reconciliationExplainRightImage.hidden = NO;
            [_reconciliationExplainTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_reconciliationExplainOne.mas_bottom).offset(13);
                make.height.mas_equalTo(14);
                
                //用于撑开container。注意不要设置container高度相关的约束。
                make.bottom.equalTo(_topInfoBackView).offset(-13);
            }];
            
            [_reconciliationExplainAllClickBtn mas_updateConstraints:^(MASConstraintMaker *make) {
               
                make.height.mas_equalTo(14);
            }];
            
        }else {
            
            _reconciliationExplainTwo.hidden = YES;
            _reconciliationExplainBtn.hidden = YES;
            _reconciliationExplainAllClickBtn.hidden = YES;
            _reconciliationExplainRightImage.hidden = YES;
            [_reconciliationExplainTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_reconciliationExplainOne.mas_bottom).offset(0);
                make.height.mas_equalTo(0);
                
                //用于撑开container。注意不要设置container高度相关的约束。
                make.bottom.equalTo(_topInfoBackView).offset(-9);
            }];
            
            [_reconciliationExplainAllClickBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(0);
            }];
        }
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)initializeAppearance {
    
    [self.view addSubview:self.showWayView];
    [self.showWayView addSubview:self.showWayTopLine];
    [self.showWayView addSubview:self.showWayLabel];
    [self.showWayView addSubview:self.showWayInfo];
    [self.showWayView addSubview:self.rightArrowImage];
    [self.showWayView addSubview:self.showWayBottomLine];
    
    
    [self.view addSubview:self.topInfoBackView];
    [self.topInfoBackView addSubview:self.infoBackTopLine];
    [self.topInfoBackView addSubview:self.needReconciliationLabel];
    [self.topInfoBackView addSubview:self.reconciliationSwitch];
    [self.topInfoBackView addSubview:self.line];
    [self.topInfoBackView addSubview:self.reconciliationExplainOne];
    [self.topInfoBackView addSubview:self.reconciliationExplainBtn];
    [self.topInfoBackView addSubview:self.reconciliationExplainTwo];
    [self.topInfoBackView addSubview:self.reconciliationExplainAllClickBtn];
    
    [self.topInfoBackView addSubview:self.reconciliationExplainRightImage];
    [self.topInfoBackView addSubview:self.infoBackBottomLine];
    
    
    [self setUpLayout];

}

- (void)setUpLayout {
    
    [_showWayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(50);
    }];
    
    [_showWayTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    CGSize wayLabelSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 13) content:@"记工显示方式" font:15];
    [_showWayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(13);
        make.centerY.mas_offset(0);
        make.height.mas_equalTo(14);
        make.width.mas_equalTo(wayLabelSize.width + 1);
    }];
    
    [_rightArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_offset(0);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
        make.right.mas_equalTo(-13);
    }];
    
    [_showWayInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_showWayLabel.mas_right).offset(50);
        make.centerY.mas_offset(0);
        make.right.equalTo(_rightArrowImage.mas_left).offset(-8);
        make.height.mas_equalTo(14);
    }];
    
    [_showWayBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        
    }];
    
    [_topInfoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_equalTo(0);
        make.top.equalTo(_showWayView.mas_bottom).offset(20);
    }];
    
    [_infoBackTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    CGSize needSize = [NSString stringWithContentSize:CGSizeMake(CGFLOAT_MAX, 15) content:@"我要对账" font:15];
    [_needReconciliationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(16);
        make.width.mas_equalTo(needSize.width + 1);
        make.height.mas_equalTo(15);
        
    }];
    
    [_reconciliationSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_needReconciliationLabel.mas_centerY).offset(0);
        make.right.mas_equalTo(-13);
        make.width.mas_equalTo(51);
        make.height.mas_equalTo(31);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.equalTo(_reconciliationSwitch.mas_bottom).offset(7);
        make.height.mas_equalTo(1);
    }];
    
    CGSize explainSize = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 26, CGFLOAT_MAX) content:@"关闭“我要对账”，所有的记工记账只有自己可见，同时，对方也不能查看你对他的记工记账" font:12];
    [_reconciliationExplainOne mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.equalTo(_line.mas_bottom).offset(10);
        make.height.mas_equalTo(explainSize.height + 1);
    }];
    
    [_reconciliationExplainTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(13);
        make.top.equalTo(_reconciliationExplainOne.mas_bottom).offset(0);
        make.height.mas_equalTo(0);
        
        //用于撑开container。注意不要设置container高度相关的约束。
        make.bottom.equalTo(_topInfoBackView).offset(-9);
    }];
    
    [_reconciliationExplainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_reconciliationExplainTwo.mas_centerY).offset(0);
        make.height.mas_equalTo(13);
        make.left.equalTo(_reconciliationExplainTwo.mas_right).offset(10);
    }];
    
    [_reconciliationExplainAllClickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.left.mas_equalTo(0);
        make.centerY.equalTo(_reconciliationExplainTwo.mas_centerY).offset(0);
        make.height.mas_equalTo(0);
    }];
    
    [_reconciliationExplainRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_reconciliationExplainTwo.mas_centerY).offset(0);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
        make.left.equalTo(_reconciliationExplainBtn.mas_right).offset(0);
    }];
    
    [_infoBackBottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
    
}

- (void)valueChanged:(UISwitch *)sender {
    
    if (!sender.on) {
        
        TYWeakSelf(self);
        
        JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
        
        NSString *popDetail = popDetail = @"确定要关闭自动对账吗？";
        
        desModel.popDetail = popDetail;
        
        desModel.leftTilte = @"取消";
        
        desModel.rightTilte = @"确定";
        
        desModel.popTextAlignment = NSTextAlignmentCenter;
        
        JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
        
        alertView.messageLable.textAlignment = NSTextAlignmentCenter;
        
        alertView.onOkBlock = ^{
            
            [self setRecordConfirmOnOffWithOnOrOff:sender.on];
        };
        
        alertView.leftButtonBlock = ^{
          
            weakself.reconciliationSwitch.on = !sender.on;
        };
        
        alertView.touchDismissBlock = ^{
          
            weakself.reconciliationSwitch.on = !sender.on;
        };
    }else {
        
        [self setRecordConfirmOnOffWithOnOrOff:sender.on];
    }
    
}

- (void)setRecordConfirmOnOffWithOnOrOff:(BOOL)onOrOff {
    
    [TYLoadingHub showLoadingWithMessage:nil];
    [JLGHttpRequest_AFN PostWithNapi:@"workday/set-record-confirm-on-off" parameters:@{@"status":@(!onOrOff)} success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        if (onOrOff) {
            
            self.reconciliationExplainTwo.hidden = NO;
            self.reconciliationExplainBtn.hidden = NO;
            _reconciliationExplainRightImage.hidden = NO;
            _reconciliationExplainAllClickBtn.hidden = NO;
            [self.reconciliationExplainTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_reconciliationExplainOne.mas_bottom).offset(13);
                make.height.mas_equalTo(14);
                
                //用于撑开container。注意不要设置container高度相关的约束。
                make.bottom.equalTo(_topInfoBackView).offset(-13);
            }];
            
            [_reconciliationExplainAllClickBtn mas_updateConstraints:^(MASConstraintMaker *make) {
               
                make.height.mas_equalTo(14);
                
            }];
            if ([self.delegate respondsToSelector:@selector(recordWorkpointsSettingOpenOrClose:)]) {
                
                [self.delegate recordWorkpointsSettingOpenOrClose:YES];
            }
            
        }else {
            
            self.reconciliationExplainTwo.hidden = YES;
            self.reconciliationExplainBtn.hidden = YES;
            _reconciliationExplainRightImage.hidden = YES;
            _reconciliationExplainAllClickBtn.hidden = YES;
            [self.reconciliationExplainTwo mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(_reconciliationExplainOne.mas_bottom).offset(0);
                make.height.mas_equalTo(0);
                
                //用于撑开container。注意不要设置container高度相关的约束。
                make.bottom.equalTo(_topInfoBackView).offset(-9);
            }];
            
            [_reconciliationExplainAllClickBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                
                make.height.mas_equalTo(0);
                
            }];
            
            if ([self.delegate respondsToSelector:@selector(recordWorkpointsSettingOpenOrClose:)]) {
                
                [self.delegate recordWorkpointsSettingOpenOrClose:NO];
            }
        }
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)choiceWay {
    
    JGJAccountShowTypeVc *typeVc = [[JGJAccountShowTypeVc alloc] init];
    typeVc.selTypeModel = self.selTypeModel;
    [self.navigationController pushViewController:typeVc animated:YES];
}

// 查看记账对象是否开启我要对账功能
- (void)gotoPeopleMakeReconciliationVC {
    
    JGJPeopleIsOpenReconciliationFunctionViewController *peopleVC = [[JGJPeopleIsOpenReconciliationFunctionViewController alloc] init];
    [self.navigationController pushViewController:peopleVC animated:YES];
}

- (UIView *)topInfoBackView {
    
    if (!_topInfoBackView) {
        
        _topInfoBackView = [[UIView alloc] init];
        _topInfoBackView.backgroundColor = AppFontffffffColor;
    }
    return _topInfoBackView;
}

- (UILabel *)needReconciliationLabel {
    
    if (!_needReconciliationLabel) {
        
        _needReconciliationLabel = [[UILabel alloc] init];
        _needReconciliationLabel.text = @"我要对账";
        _needReconciliationLabel.textColor = AppFont333333Color;
        _needReconciliationLabel.font = FONT(AppFont30Size);
    }
    return _needReconciliationLabel;
}

- (UISwitch *)reconciliationSwitch {
    
    if (!_reconciliationSwitch) {
        
        _reconciliationSwitch = [[UISwitch alloc] init];
        _reconciliationSwitch.on = NO;
        [_reconciliationSwitch addTarget:self action:@selector(valueChanged:) forControlEvents:(UIControlEventValueChanged)];
    }
    return _reconciliationSwitch;
}

- (UIView *)line {
    
    if (!_line) {
        
        _line = [[UIView alloc] init];
        _line.backgroundColor = AppFontdbdbdbColor;
    }
    return _line;
}

- (UILabel *)reconciliationExplainOne {
    
    if (!_reconciliationExplainOne) {
        
        _reconciliationExplainOne = [[UILabel alloc] init];
        _reconciliationExplainOne.text = @"关闭“我要对账”，所有的记工记账只有自己可见，同时，对方也不能查看你对他的记工记账";
        _reconciliationExplainOne.textColor = AppFont666666Color;
        _reconciliationExplainOne.font = FONT(AppFont24Size);
        _reconciliationExplainOne.numberOfLines = 0;
    }
    return _reconciliationExplainOne;
}

- (UILabel *)reconciliationExplainTwo {
    
    if (!_reconciliationExplainTwo) {
        
        _reconciliationExplainTwo = [[UILabel alloc] init];
        _reconciliationExplainTwo.text = @"查看我的记工对象是否开启了“我要对账”";
        _reconciliationExplainTwo.textColor = AppFont1892E7Color;
        _reconciliationExplainTwo.font = FONT(AppFont28Size);
        _reconciliationExplainTwo.hidden = YES;
//        _reconciliationExplainTwo.userInteractionEnabled = YES;
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoPeopleMakeReconciliationVC)];
//        [_reconciliationExplainTwo addGestureRecognizer:gesture];
    }
    return _reconciliationExplainTwo;
}

- (SJButton *)reconciliationExplainBtn {
    
    if (!_reconciliationExplainBtn) {
        
        _reconciliationExplainBtn = [SJButton buttonWithType:SJButtonTypeHorizontalTitleImage];
        _reconciliationExplainBtn.notNeedTheTrackingEffect = YES;
        [_reconciliationExplainBtn setTitleColor:AppFont1892E7Color forState:SJControlStateNormal];
        [_reconciliationExplainBtn setTitle:@"查看" forState:(SJControlStateNormal)];
        _reconciliationExplainBtn.hidden = YES;
        _reconciliationExplainBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//        [_reconciliationExplainBtn addTarget:self action:@selector(gotoPeopleMakeReconciliationVC) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _reconciliationExplainBtn;
}

- (UIButton *)reconciliationExplainAllClickBtn {
    
    if (!_reconciliationExplainAllClickBtn) {
        
        _reconciliationExplainAllClickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _reconciliationExplainAllClickBtn.hidden = YES;
        [_reconciliationExplainAllClickBtn addTarget:self action:@selector(gotoPeopleMakeReconciliationVC) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reconciliationExplainAllClickBtn;
}

- (UIImageView *)reconciliationExplainRightImage {
    
    if (!_reconciliationExplainRightImage) {
        
        _reconciliationExplainRightImage = [[UIImageView alloc] init];
        _reconciliationExplainRightImage.image = IMAGE(@"blue_arrow_right");
        _reconciliationExplainRightImage.contentMode = UIViewContentModeRight;
        _reconciliationExplainRightImage.hidden = YES;
    }
    return _reconciliationExplainRightImage;
}

- (UIView *)infoBackTopLine {
    
    if (!_infoBackTopLine) {
        
        _infoBackTopLine = [[UIView alloc] init];
        _infoBackTopLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _infoBackTopLine;
}

- (UIView *)infoBackBottomLine {
    
    if (!_infoBackBottomLine) {
        
        _infoBackBottomLine = [[UIView alloc] init];
        _infoBackBottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _infoBackBottomLine;
}

- (UIView *)showWayView {
    
    if (!_showWayView) {
        
        _showWayView = [[UIView alloc] init];
        _showWayView.userInteractionEnabled = YES;
        _showWayView.backgroundColor = AppFontffffffColor;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choiceWay)];
        [_showWayView addGestureRecognizer:gesture];
        
    }
    return _showWayView;
}

- (UIView *)showWayTopLine {
    
    if (!_showWayTopLine) {
        
        _showWayTopLine = [[UIView alloc] init];
        _showWayTopLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _showWayTopLine;
}

- (UILabel *)showWayLabel {
    
    if (!_showWayLabel) {
        
        _showWayLabel = [[UILabel alloc] init];
        _showWayLabel.text = @"记工显示方式";
        _showWayLabel.textColor = AppFont333333Color;
        _showWayLabel.font = FONT(AppFont30Size);
    }
    return _showWayLabel;
}

- (UILabel *)showWayInfo {
    
    if (!_showWayInfo) {
        
        _showWayInfo = [[UILabel alloc] init];
        _showWayInfo.textColor = AppFontEB4E4EColor;
        _showWayInfo.font = FONT(AppFont28Size);
        _showWayInfo.textAlignment = NSTextAlignmentRight;
        
    }
    return _showWayInfo;
}

- (UIImageView *)rightArrowImage {
    
    if (!_rightArrowImage) {
        
        _rightArrowImage = [[UIImageView alloc] init];
        _rightArrowImage.image = IMAGE(@"arrow_right");
        _rightArrowImage.contentMode = UIViewContentModeRight;
    }
    return _rightArrowImage;
}

- (UIView *)showWayBottomLine {
    
    if (!_showWayBottomLine) {
        
        _showWayBottomLine = [[UIView alloc] init];
        _showWayBottomLine.backgroundColor = AppFontdbdbdbColor;
    }
    return _showWayBottomLine;
    
}


@end

//
//  JGJNewHomeMyTeamOrGroupView.m
//  mix
//
//  Created by Tony on 2019/3/5.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNewHomeMyTeamOrGroupView.h"
#import "JGJChatMsgDBManger+JGJGroupDB.h"
@interface JGJNewHomeMyTeamOrGroupView ()

@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) UILabel *myTeamOrGroupInfo;
@property (nonatomic, strong) UIView *redDotLabel;
@property (nonatomic, strong) UILabel *gotoLabel;
@property (nonatomic, strong) UIButton *gotoBtn;
@property (nonatomic, strong) UIImageView *rightImageView;

@end
@implementation JGJNewHomeMyTeamOrGroupView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = AppFontffffffColor;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.logoImageView];
    [self addSubview:self.myTeamOrGroupInfo];
    [self addSubview:self.redDotLabel];
    [self addSubview:self.gotoLabel];
    [self addSubview:self.rightImageView];
    [self addSubview:self.gotoBtn];
    [self setUpLayout];
    
    [_redDotLabel updateLayout];
    _redDotLabel.layer.cornerRadius = 4;
}

- (void)setUpLayout {
    
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(0);
        make.left.mas_equalTo(10);
        make.width.height.mas_equalTo(32);
    }];
    
    [_myTeamOrGroupInfo mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(0);
        make.left.equalTo(_logoImageView.mas_right).offset(8);
        make.height.mas_equalTo(16);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.mas_offset(0);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(6);
        make.height.mas_equalTo(10);
    }];
    
    [_gotoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_rightImageView.mas_left).offset(-10);
        make.centerY.mas_offset(0);
        make.height.mas_equalTo(14);
    }];
    
    [_redDotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_gotoLabel.mas_right).offset(-2);
        make.width.height.mas_equalTo(8);
        make.top.mas_equalTo(13);
    }];
    
    [_gotoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
    }];
    
}


- (void)isShowRedDot {
    
    BOOL isShowRedDotView = NO;
    // 1. 先判断所有消息列表是否有未读数
    NSInteger unreadMsgCount = [JGJChatMsgDBManger getAllUnreadMsgCountWithOutWork_activity_Recruit];
    if (unreadMsgCount > 0) {
        
        isShowRedDotView = YES;
        
    }else {
        
        if ([JGJChatMsgDBManger getRowCountWithResultList] > 0) {

            isShowRedDotView = YES;

        }else {

            isShowRedDotView = NO;
        }
    }
    
    _redDotLabel.hidden = !isShowRedDotView;
    
}

- (void)gotoMyTeamOrGroupVC {
    
    if (self.gotoMyTeamOrGroupBlock) {
        
        _gotoMyTeamOrGroupBlock();
    }
    
}

- (UIImageView *)logoImageView {
    
    if (!_logoImageView) {
        
        _logoImageView = [[UIImageView alloc] init];
        _logoImageView.image = IMAGE(@"myTeamOrGroupImage");
    }
    return _logoImageView;
}

- (UILabel *)myTeamOrGroupInfo {
    
    if (!_myTeamOrGroupInfo) {
        
        _myTeamOrGroupInfo = [[UILabel alloc] init];
        _myTeamOrGroupInfo.text = @"我的项目班组";
        _myTeamOrGroupInfo.textColor = AppFont000000Color;
        _myTeamOrGroupInfo.font = [UIFont boldSystemFontOfSize:17];
        
    }
    return _myTeamOrGroupInfo;
}

- (UIView *)redDotLabel {
    
    if (!_redDotLabel) {
        
        _redDotLabel = [[UIView alloc] init];
        _redDotLabel.clipsToBounds = YES;
        _redDotLabel.backgroundColor = [UIColor redColor];
        _redDotLabel.hidden = YES;
    }
    return _redDotLabel;
}

- (UILabel *)gotoLabel {
    
    if (!_gotoLabel) {
        
        _gotoLabel = [[UILabel alloc] init];
        _gotoLabel.text = @"进入";
        _gotoLabel.font = FONT(15);
        _gotoLabel.textColor = AppFont666666Color;
        _gotoLabel.textAlignment = NSTextAlignmentRight;
    }
    return _gotoLabel;
}

- (UIButton *)gotoBtn {
    
    if (!_gotoBtn) {
        
        _gotoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _gotoBtn.backgroundColor = [UIColor clearColor];
        [_gotoBtn addTarget:self action:@selector(gotoMyTeamOrGroupVC) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _gotoBtn;
}

- (UIImageView *)rightImageView {
    
    if (!_rightImageView) {
        
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = IMAGE(@"arrow_right");
        _rightImageView.contentMode = UIViewContentModeRight;
    }
    return _rightImageView;
}

@end

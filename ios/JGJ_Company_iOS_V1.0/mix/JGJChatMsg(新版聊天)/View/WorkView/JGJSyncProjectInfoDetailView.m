//
//  JGJSyncProjectInfoDetailView.m
//  mix
//
//  Created by Tony on 2018/12/12.
//  Copyright © 2018 JiZhi. All rights reserved.
//

#import "JGJSyncProjectInfoDetailView.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
@interface JGJSyncProjectInfoDetailView ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UILabel *leftLabel;

@property (nonatomic, strong) UILabel *middleLabel;
@property (nonatomic, strong) UIImageView *middleImageView;

@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *rightLabel;

@property (nonatomic, strong) UILabel *firstPointLabel;
@property (nonatomic, strong) UILabel *firstInfoLabel;

@property (nonatomic, strong) UILabel *secondPointLabel;
@property (nonatomic, strong) UILabel *secondInfoLabel;

@property (nonatomic, strong) UILabel *thirdPointLabel;
@property (nonatomic, strong) UILabel *thirdInfoLabel;

@end
@implementation JGJSyncProjectInfoDetailView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.leftImageView];
    [self addSubview:self.leftLabel];
    
    [self addSubview:self.middleImageView];
    [self addSubview:self.middleLabel];
    
    [self addSubview:self.rightImageView];
    [self addSubview:self.rightLabel];
    
    [self addSubview:self.firstPointLabel];
    [self addSubview:self.firstInfoLabel];
    
    [self addSubview:self.secondPointLabel];
    [self addSubview:self.secondInfoLabel];
    
    [self addSubview:self.thirdPointLabel];
    [self addSubview:self.thirdInfoLabel];
    [self setUpLayout];
    
    [_firstPointLabel updateLayout];
    [_secondPointLabel updateLayout];
    [_thirdPointLabel updateLayout];
    
    _firstPointLabel.clipsToBounds = YES;
    _firstPointLabel.layer.cornerRadius = 9;
    
    _secondPointLabel.clipsToBounds = YES;
    _secondPointLabel.layer.cornerRadius = 9;
    
    _thirdPointLabel.clipsToBounds = YES;
    _thirdPointLabel.layer.cornerRadius = 9;
    
}

- (void)setUpLayout {
    
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(58);
        make.top.mas_equalTo(33);
        make.width.height.mas_equalTo(60);
    }];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(_leftImageView.mas_centerX).offset(0);
        make.top.equalTo(_leftImageView.mas_bottom).offset(7);
        make.height.mas_equalTo(13);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.mas_equalTo(-58);
        make.top.mas_equalTo(33);
        make.width.height.mas_equalTo(60);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(_rightImageView.mas_centerX).offset(0);
        make.top.equalTo(_leftImageView.mas_bottom).offset(7);
        make.height.mas_equalTo(13);
    }];
    
    [_middleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_leftImageView.mas_centerY).offset(10);
        make.left.mas_equalTo(_leftImageView.mas_right).offset(13);
        make.right.mas_equalTo(_rightImageView.mas_left).offset(-13);
        make.height.mas_equalTo(12);
    }];
    
    [_middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.bottom.equalTo(_middleImageView.mas_top).offset(-4);
        make.height.mas_equalTo(13);
    }];
    
    [_firstPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.top.equalTo(_leftLabel.mas_bottom).offset(38);
        make.width.height.mas_equalTo(18);
    }];
    
    CGFloat firstContentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 58, CGFLOAT_MAX) content:_firstInfoLabel.text font:AppFont30Size].height + 5;
    
    [_firstInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(_firstPointLabel.mas_right).offset(11);
        make.right.mas_equalTo(-19);
        make.top.equalTo(_firstPointLabel.mas_top).offset(-4);
        make.height.mas_equalTo(firstContentHeight);
    }];
    
    [_secondPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.equalTo(_firstInfoLabel.mas_bottom).offset(11);
        make.width.height.mas_equalTo(18);
    }];
    
    CGFloat secondContentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 58, CGFLOAT_MAX) content:_secondInfoLabel.text font:AppFont30Size].height + 5;
    
    [_secondInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_secondPointLabel.mas_right).offset(11);
        make.right.mas_equalTo(-19);
        make.top.equalTo(_secondPointLabel.mas_top).offset(-4);
        make.height.mas_equalTo(secondContentHeight);
    }];
    
    [_thirdPointLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.equalTo(_secondInfoLabel.mas_bottom).offset(11);
        make.width.height.mas_equalTo(18);
    }];
    
    CGFloat thirdContentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 58, CGFLOAT_MAX) content:_thirdInfoLabel.text font:AppFont30Size].height + 5;
    
    [_thirdInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_thirdPointLabel.mas_right).offset(11);
        make.right.mas_equalTo(-19);
        make.top.equalTo(_thirdPointLabel.mas_top).offset(-4);
        make.height.mas_equalTo(thirdContentHeight);
    }];
    
}

- (void)setMsgModel:(JGJChatMsgListModel *)msgModel {
    
    _msgModel = msgModel;
    
    
    if (_msgModel.chatListType == JGJChatListDemandSyncProjectType) {// 同步项目请求
        
        _leftLabel.text = @"项目管理人";
        _rightLabel.text = @"班组长/项目负责人";
        [_firstInfoLabel markattributedTextArray:@[@"[同意]",@"[拒绝]"] color:AppFont000000Color];
        [_thirdInfoLabel markattributedTextArray:@[@"首页> 右上角“+”号 > 同步项目",@"取消同步"] color:AppFont000000Color];
       
    }else if (_msgModel.chatListType == JGJChatListSyncProjectToYouType) {// 创建新项目/加入现有项目组

        _leftLabel.text = @"班组长/项目负责人";
        _rightLabel.text = @"项目管理人";
        _middleLabel.text = @"主动同步项目给";
        
        _leftImageView.image = IMAGE(@"teamLeaderLogo");
        _rightImageView.image = IMAGE(@"projectManagerLogo");
        _middleImageView.image = IMAGE(@"syncProjectInfoSinglearrows");
        
        _firstInfoLabel.text = @"用户主动将班组、项目组的记工数据同步给项目管理人员，项目管理人员可通过此功能获取项目用工数据(开工人数、上班工天、加班工天)，实现劳务用工智能管理。";
        CGFloat firstContentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 58, CGFLOAT_MAX) content:_firstInfoLabel.text font:AppFont30Size].height + 5;
        [_firstInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(firstContentHeight);
        }];
        
        _secondInfoLabel.text = @"加入新项目或者创建新项目后，项目管理人员可在 吉工宝APP > 记工报表 清晰的查看各班组所在项目的详细记工数据。";
        CGFloat secondContentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 58, CGFLOAT_MAX) content:_secondInfoLabel.text font:AppFont30Size].height + 5;
        [_secondInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(secondContentHeight);
        }];
        
        _thirdInfoLabel.text = @"同步项目后能使用工管理透明化、减少劳务纠纷、 项目管理科学高效、为项目成本分析作数据积累。";
        CGFloat thirdContentHeight = [NSString stringWithContentSize:CGSizeMake(TYGetUIScreenWidth - 58, CGFLOAT_MAX) content:_thirdInfoLabel.text font:AppFont30Size].height + 5;
        [_thirdInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(thirdContentHeight);
        }];
        
        [_secondInfoLabel markattributedTextArray:@[@"吉工宝APP > 记工报表"] color:AppFont000000Color];
    }
    
    
    
}

- (UIImageView *)leftImageView {
    
    if (!_leftImageView) {
        
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = IMAGE(@"projectManagerLogo");
    }
    return _leftImageView;
}

- (UILabel *)leftLabel {

    if (!_leftLabel) {
        
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"项目管理人";
        _leftLabel.textColor = AppFont666666Color;
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        _leftLabel.font = FONT(AppFont26Size);
    }
    return _leftLabel;
}

- (UILabel *)middleLabel {
    
    if (!_middleLabel) {
        
        _middleLabel = [[UILabel alloc] init];
        _middleLabel.text = @"要求同步项目";
        _middleLabel.textColor = AppFont333333Color;
        _middleLabel.textAlignment = NSTextAlignmentCenter;
        _middleLabel.font = FONT(AppFont26Size);
    }
    return _middleLabel;
}

- (UIImageView *)middleImageView {
    
    if (!_middleImageView) {
        
        _middleImageView = [[UIImageView alloc] init];
        _middleImageView.image = IMAGE(@"syncProjectInfoSinglearrows");
    }
    return _middleImageView;
}

- (UIImageView *)rightImageView {
    
    if (!_rightImageView) {
        
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = IMAGE(@"teamLeaderLogo");
    }
    return _rightImageView;
}

- (UILabel *)rightLabel {
    
    if (!_rightLabel) {
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = @"项目负责人/班组长";
        _rightLabel.textColor = AppFont666666Color;
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        _rightLabel.font = FONT(AppFont26Size);
    }
    return _rightLabel;
}

- (UILabel *)firstPointLabel {
    
    if (!_firstPointLabel) {
        
        _firstPointLabel = [[UILabel alloc] init];
        _firstPointLabel.text = @"1";
        _firstPointLabel.textColor = [UIColor whiteColor];
        _firstPointLabel.backgroundColor = AppFontEB4E4EColor;
        _firstPointLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _firstPointLabel;
}

- (UILabel *)firstInfoLabel {
    
    if (!_firstInfoLabel) {
        
        _firstInfoLabel = [[UILabel alloc] init];
        _firstInfoLabel.text = @"对方向你发起记工同步请求，你可以 [同意] 或者 [拒绝] 同步请求。";
        _firstInfoLabel.textColor = AppFont666666Color;
        _firstInfoLabel.font = FONT(AppFont30Size);
        _firstInfoLabel.numberOfLines = 0;
        _firstInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _firstInfoLabel;
}


- (UILabel *)secondPointLabel {
    
    if (!_secondPointLabel) {
        
        _secondPointLabel = [[UILabel alloc] init];
        _secondPointLabel.text = @"2";
        _secondPointLabel.textColor = [UIColor whiteColor];
        _secondPointLabel.backgroundColor = AppFontEB4E4EColor;
        _secondPointLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secondPointLabel;
}

- (UILabel *)secondInfoLabel {
    
    if (!_secondInfoLabel) {
        
        _secondInfoLabel = [[UILabel alloc] init];
        _secondInfoLabel.text = @"同步项目后，记工情况会根据班组长记工数据变化及时更新，同步方能看到项目的工天数、开工工人信息，但不能看到具体的工钱金额。";
        _secondInfoLabel.textColor = AppFont666666Color;
        _secondInfoLabel.font = FONT(AppFont30Size);
        _secondInfoLabel.numberOfLines = 0;
        _secondInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _secondInfoLabel;
}

- (UILabel *)thirdPointLabel {
    
    if (!_thirdPointLabel) {
        
        _thirdPointLabel = [[UILabel alloc] init];
        _thirdPointLabel.text = @"3";
        _thirdPointLabel.textColor = [UIColor whiteColor];
        _thirdPointLabel.backgroundColor = AppFontEB4E4EColor;
        _thirdPointLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _thirdPointLabel;
}

- (UILabel *)thirdInfoLabel {
    
    if (!_thirdInfoLabel) {
        
        _thirdInfoLabel = [[UILabel alloc] init];
        _thirdInfoLabel.text = @"在吉工宝 首页> 右上角“+”号 > 同步项目 中查看同步给他人的项目，也可对已经同步项目进行 取消同步 操作，或者删除同步人。";
        _thirdInfoLabel.textColor = AppFont666666Color;
        _thirdInfoLabel.font = FONT(AppFont30Size);
        _thirdInfoLabel.numberOfLines = 0;
        _thirdInfoLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _thirdInfoLabel;
}

@end

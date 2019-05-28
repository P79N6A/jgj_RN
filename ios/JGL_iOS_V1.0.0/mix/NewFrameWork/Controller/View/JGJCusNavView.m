//
//  JGJCusNavView.m
//  JGJCompany
//
//  Created by yj on 17/3/29.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCusNavView.h"
#import "JSBadgeView.h"
#import "NSString+Extend.h"

#define ButtonTop TYIST_IPHONE_X ? 25 : 13

@interface JGJCusNavView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) JSBadgeView *badgeView ;

@property (weak, nonatomic) IBOutlet UIButton *workMsgButton;

@property (weak, nonatomic) IBOutlet UIButton *topMoreButton;

@property (weak, nonatomic) IBOutlet UIView *msgFlagView;

@property (weak, nonatomic) UIImageView *maskImageView;

@property (strong, nonatomic) UIView *lineView;

@property (strong, nonatomic) UIView *sysflagView;

//当前角色
@property (strong, nonatomic) UILabel *roleLable;
@end

@implementation JGJCusNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        TYWeakSelf(self);
        
        self.cusNavViewBlock = ^{
            
            [weakself setTopButtonUI];
        };
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

//设置顶部按钮
- (void)setTopButtonUI {
    
    UIButton *workMsgButton = [UIButton new];
    
    workMsgButton.titleLabel.font = [UIFont systemFontOfSize:AppFont32Size];
    
    NSString *role = JLGisLeaderBool ? @"我是班组长" : @"我是工人";
    
    [workMsgButton setTitle:role forState:UIControlStateNormal];
    
    workMsgButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [workMsgButton addTarget:self action:@selector(handleHomeWorkInfoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //    sys_msg_icon
    [workMsgButton setImage:[UIImage imageNamed:@"change_role_icon"] forState:UIControlStateNormal];
    
    workMsgButton.adjustsImageWhenHighlighted = NO;
    
    self.workMsgButton = workMsgButton;
    
    [self.superview addSubview:workMsgButton];
    
    UIButton *moreButton = [UIButton new];
    
    moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [moreButton addTarget:self action:@selector(handleHomeNavMoreButtonpressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [moreButton setImage:[UIImage imageNamed:@"more_type_sel_icon"] forState:UIControlStateNormal];
    
    moreButton.adjustsImageWhenHighlighted = NO;
    
    self.topMoreButton = moreButton;
    [self.superview addSubview:self.netWorkingHeader];
    [self.superview addSubview:moreButton];
    
    [self.netWorkingHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(JGJ_StatusBar_Height);
        make.height.mas_equalTo(0);
    }];
    
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(TYGetUIScreenWidth - 60);
        
        make.top.mas_equalTo(ButtonTop);
        
        make.size.mas_equalTo(CGSizeMake(55, 45));
    }];
    
    [workMsgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        
        make.centerY.mas_equalTo(moreButton.mas_centerY);
        
        make.size.mas_equalTo(CGSizeMake(120, 45));
    }];
    
    CGFloat sysflagViewWH = 8.0;
    
    UIView *sysflagView = [UIView new];
    
    self.sysflagView = sysflagView;
    
    [sysflagView.layer setLayerCornerRadius:sysflagViewWH / 2.0];
    
    sysflagView.backgroundColor = AppFontFF0000Color;
    
    [workMsgButton addSubview:sysflagView];
    
    [sysflagView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(20);
        
        make.top.mas_equalTo(10);
        
        make.size.mas_equalTo(CGSizeMake(sysflagViewWH, sysflagViewWH));
    }];
}

- (void)setNetWorkStatus:(AFNetworkReachabilityStatus)netWorkStatus {
    
    if (netWorkStatus == AFNetworkReachabilityStatusUnknown || netWorkStatus == AFNetworkReachabilityStatusNotReachable) {
        
        [self.topMoreButton mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(ButtonTop + 40);
        }];
        
        [self.netWorkingHeader mas_updateConstraints:^(MASConstraintMaker *make) {

            make.height.mas_equalTo(40);
        }];

        self.netWorkingHeader.hidden = NO;
    }else {
        
        [self.topMoreButton mas_updateConstraints:^(MASConstraintMaker *make) {

            make.top.mas_equalTo(ButtonTop);
        }];
        [self.netWorkingHeader mas_updateConstraints:^(MASConstraintMaker *make) {

            make.height.mas_equalTo(0);
        }];

        self.netWorkingHeader.hidden = YES;
    }
}
-(void)setupView{
    
    
    UIImageView *maskImageView = [UIImageView new];
    
    self.maskImageView = maskImageView;
    
    maskImageView.image = [UIImage imageNamed:@"home_banerBack_icon"];
    
    [self addSubview:maskImageView];
    
    [self.maskImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
    }];
    
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    
    UIView *lineView = [UIView new];
    
    self.lineView = lineView;
    
    lineView.backgroundColor = AppFontdbdbdbColor;
    
    [self addSubview:lineView];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        
        make.height.mas_equalTo(0.5);
        
    }];
    
    
    
}

- (void)setUnReadinfoModel:(JGJWorkCircleMiddleInfoModel *)unReadinfoModel {
    
    _unReadinfoModel = unReadinfoModel;
    
    self.msgFlagView.hidden = [unReadinfoModel.unread_msg_count isEqualToString:@"0"] || [NSString isEmpty:unReadinfoModel.unread_msg_count];
    
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    
    _proListModel = proListModel;
    
    self.sysflagView.hidden = [proListModel.unread_system_count isEqualToString:@"0"] || [NSString isEmpty:proListModel.unread_system_count];
}

- (void)setCusNavAlpha:(CGFloat)cusNavAlpha {
    
    _cusNavAlpha = cusNavAlpha;
    
    UIColor *navbackColor = AppFontfafafaColor;
    
    self.backgroundColor = [navbackColor colorWithAlphaComponent:cusNavAlpha];
    
    NSString *workMsgStr = @"change_role_icon";
    
    NSString *topMoreButtonImagestr = @"more_type_sel_icon";
    
    UIColor *textColor = AppFontffffffColor;
    
    if (cusNavAlpha == 1.0) {
        
        workMsgStr = @"change_role_red_icon";
        
        topMoreButtonImagestr = @"more_type_sel_red_icon";
        
        self.lineView.hidden = NO;
        
        textColor = AppFontEB4E4EColor;
        
        
    }else {
        
        self.lineView.hidden = YES;
    }
    
    [self.workMsgButton setTitleColor:textColor forState:UIControlStateNormal];
    
    [self.workMsgButton setImage:[UIImage imageNamed:workMsgStr] forState:UIControlStateNormal];
    
    [self.topMoreButton setImage:[UIImage imageNamed:topMoreButtonImagestr] forState:UIControlStateNormal];
    
    self.maskImageView.alpha = 1 - cusNavAlpha;
    
    
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.workMsgButton alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgePositionAdjustment = CGPointMake(-3, 3);
        _badgeView.badgeBackgroundColor = TYColorHex(0xef272f);
        _badgeView.badgeTextFont = [UIFont systemFontOfSize:AppFont24Size];
        _badgeView.badgeStrokeColor = [UIColor redColor];
    }
    return _badgeView;
}

- (IBAction)handleHomeNavMoreButtonpressed:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(customNavViewWithNavView:didSelectedButtonType:)]) {
        
        [self.delegate customNavViewWithNavView:self didSelectedButtonType:JGJCusNavViewMoreButtonType];
    }
}

- (IBAction)handleHomeWorkInfoButtonPressed:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(customNavViewWithNavView:didSelectedButtonType:)]) {
        
        [self.delegate customNavViewWithNavView:self didSelectedButtonType:JGJCusNavViewSelRoleButtonType];
    }
}

- (JGJNetWorkingStatusHeaderView *)netWorkingHeader {
    
    if (!_netWorkingHeader) {
        
        _netWorkingHeader = [[JGJNetWorkingStatusHeaderView alloc] init];
        _netWorkingHeader.hidden = YES;
    }
    return _netWorkingHeader;
}


@end


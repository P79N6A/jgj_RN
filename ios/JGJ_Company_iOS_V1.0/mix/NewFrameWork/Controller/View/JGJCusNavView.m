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
        
        make.left.mas_equalTo(TYGetUIScreenWidth - 54);
        
        make.top.mas_equalTo(ButtonTop);
        
        make.size.mas_equalTo(CGSizeMake(49, 45));
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
    
    lineView.hidden = YES;
    
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
    
    NSString *workMsgStr = @"sys_msg_icon";
    
    NSString *topMoreButtonImagestr = @"more_type_sel_icon";
    
    if (cusNavAlpha == 1.0) {
        
        workMsgStr = @"sys_msg_red_icon";
        
        topMoreButtonImagestr = @"more_type_sel_red_icon";
        
        self.lineView.hidden = NO;

    }else {
        
         self.lineView.hidden = YES;
    }
    
    [self.workMsgButton setImage:[UIImage imageNamed:workMsgStr] forState:UIControlStateNormal];
    
    [self.topMoreButton setImage:[UIImage imageNamed:topMoreButtonImagestr] forState:UIControlStateNormal];
    
    self.maskImageView.alpha = 1 - cusNavAlpha;
    
}

- (JSBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[JSBadgeView alloc] initWithParentView:self.workMsgButton alignment:JSBadgeViewAlignmentTopRight];
        
        _badgeView.badgePositionAdjustment = CGPointMake(-3, 3);
        
        _badgeView.badgeBackgroundColor = AppFontEB4E4EColor;
        
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
        
        [self.delegate customNavViewWithNavView:self didSelectedButtonType:JGJCusNavViewWorkInfoButtonType];
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

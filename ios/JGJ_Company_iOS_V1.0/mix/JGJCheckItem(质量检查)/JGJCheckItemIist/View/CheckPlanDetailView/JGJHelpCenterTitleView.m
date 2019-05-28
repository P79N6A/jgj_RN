//
//  JGJHelpCenterTitleView.m
//  JGJCompany
//
//  Created by yj on 2017/11/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJHelpCenterTitleView.h"

#import "JGJWebAllSubViewController.h"

#import "UIView+GNUtil.h"

#import "JLGCustomViewController.h"

@interface JGJHelpCenterTitleView ()

@property (strong, nonatomic) UIViewController *targetVc;

@property(nonatomic,strong)   UILabel * titleLabel;//标题label

@property(nonatomic,strong)   UIImageView * titleImageView;

@property (nonatomic, strong) JGJHelpCenterTitleView *titleView;
@end

@implementation JGJHelpCenterTitleView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

+(JGJHelpCenterTitleView *)helpCenterTitleView {
    
    JGJHelpCenterTitleView *titleView = [[self alloc] init];
    
    return titleView;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.frame = CGRectMake(0, 0, 130, 40);
        
        UIButton *helpCenterButton = [UIButton new];
        
        helpCenterButton.frame = self.bounds;
        
        helpCenterButton.backgroundColor = [UIColor clearColor];
        
        [self addSubview:helpCenterButton];
        
        [helpCenterButton addTarget:self action:@selector(helpCenterButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.titleLabel = titleLabel;
        
        titleLabel.textColor = [UIColor whiteColor];
        
        titleLabel.font = [UIFont systemFontOfSize:JGJNavBarFont];
        
        [self addSubview:self.titleLabel];
        
        [self addSubview:self.titleImageView];
        
    }
    return self;
}

- (void)setTitleViewType:(JGJHelpCenterTitleViewType)titleViewType {
    
    _titleViewType = titleViewType;
    
}


-(UIImageView *)titleImageView
{
    if (!_titleImageView) {
        
        _titleImageView = [[UIImageView alloc] init];
        
        _titleImageView.contentMode = UIViewContentModeLeft;
        
        _titleImageView.image = [UIImage imageNamed:@"help_center_icon"];
    }
    return _titleImageView;
}

- (void)setTitle:(NSString *)title
{
    CGFloat height = 30.0;
    
    CGFloat iconHeight = 20.0;
    
    self.titleLabel.text = title;
    
    NSDictionary *dic = @{NSFontAttributeName : self.titleLabel.font};
    //默认的
    CGFloat width =   [self.titleLabel.text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.width;
    
    self.titleLabel.center = self.center;
    
    self.titleLabel.bounds = CGRectMake(0, 0, width, height);
    
    self.titleImageView.frame = CGRectMake(TYGetMaxX(self.titleLabel) + 5, (self.height - iconHeight) / 2.0 , iconHeight, iconHeight);
    
}


- (void)setIconHidden:(BOOL)iconHidden
{
    _iconHidden = iconHidden;
    
    self.titleImageView.hidden = _iconHidden;
}

- (void)helpCenterButtonPressed {
    
    UIViewController *targetVc = [UIView getCurrentViewControllerWithCurView:self];
    
    [self setPushHelpWebVcWithTitleViewType:self.titleViewType targetVc:targetVc];
    
}

#pragma mark - 进入帮助页面
- (void)setPushHelpWebVcWithTitleViewType:(JGJHelpCenterTitleViewType)titleViewType targetVc:(UIViewController *)targetVc {
    
    NSString *webUrl = nil;
    
    NSString *helpid = @"";
    
    switch (self.titleViewType) {
            
        case JGJHelpCenterTitleViewQualityType:{
            
            helpid = @"180";
        }
            
            break;
            
        case JGJHelpCenterTitleViewSafeType:{
            
            helpid = @"181";
        }
            
            break;
            
        case JGJHelpCenterTitleViewCheckType:{
            
            helpid = @"182";
        }
            
            break;
            
        case JGJHelpCenterTitleViewTaskType:{
            
            helpid = @"183";
        }
            
            break;
            
        case JGJHelpCenterTitleViewNotifyType:{
            
            helpid = @"184";
        }
            
            break;
            
        case JGJHelpCenterTitleViewSignType:{
            
            helpid = @"185";
        }
            
            break;
            
        case JGJHelpCenterTitleViewLogType:{
            
            helpid = @"188";
        }
            
            break;
            
        case JGJHelpCenterTitleViewGroupLogType:{
            
            helpid = @"226";
        }
            
            break;
        case JGJHelpCenterTitleViewWeatherType:{
            
            helpid = @"189";
        }
            
            break;
            
        case JGJHelpCenterTitleViewCloudType:{
            
            helpid = @"191";
        }
            
            break;
            
        case JGJHelpCenterTitleViewDataBaseType:{
            
            helpid = @"190";
        }
            
            break;
            
        default:
            break;
    }
    
    //没有图标禁止点击
    if (_iconHidden) {
        
        return;
    }
    
    webUrl = [NSString stringWithFormat:@"%@help/hpDetail?id=%@", JGJWebDiscoverURL,helpid];
    
    //    [TYShowMessage showSuccess:@"帮助按钮按下"];
    
    JGJWebAllSubViewController *webVc = [[JGJWebAllSubViewController alloc] initWithWebType:JGJWebTypeInnerURLType URL:webUrl];
    
    
    if ([targetVc isKindOfClass:NSClassFromString(@"JLGCustomViewController")]) {
        
        JLGCustomViewController *navVc = (JLGCustomViewController *)targetVc;
        
        [navVc pushViewController:webVc animated:YES];
        
    }else {
        
        [targetVc.navigationController pushViewController:webVc animated:YES];
    }
    
}


-(JGJHelpCenterTitleView *)helpCenterActionWithTitleViewType:(JGJHelpCenterTitleViewType)titleViewType target:(UIViewController *)target {
    
    [self setPushHelpWebVcWithTitleViewType:titleViewType targetVc:target];
    
    return self;
}

@end


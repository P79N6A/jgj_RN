//
//  JGJNewWorkingStatusHeaderView.m
//  mix
//
//  Created by Tony on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJNetWorkingStatusHeaderView.h"

@interface JGJNetWorkingStatusHeaderView ()


// 网络状态
@property (nonatomic, strong) UILabel *statusContent;
// 菊花图
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
// 无可用网络
@property (nonatomic, strong) UIImageView *fialImageView;
@end
@implementation JGJNetWorkingStatusHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = AppFontFFECECColor;
        [self initializeAppearance];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = AppFontFFECECColor;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    
    [self addSubview:self.statusContent];
    [self addSubview:self.activityIndicator];
    [self addSubview:self.fialImageView];
    [self setUpLayout];
}

- (void)setUpLayout {
    
    
    [_statusContent mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(self).offset(0);
        make.centerX.equalTo(self).offset(13);
        make.height.mas_equalTo(15);
    }];
    
    
    [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(_statusContent.mas_left).offset(-6);
        make.centerY.equalTo(self).offset(0);
        make.width.height.mas_equalTo(20);
    }];
    
    [_fialImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(_statusContent.mas_left).offset(-4);
        make.centerY.equalTo(self).offset(0);
        make.width.height.mas_equalTo(15);
    }];
}

- (void)setcontentWithNewWorkingStatus:(AFNetworkReachabilityStatus)status {
    
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
        {
            [_activityIndicator stopAnimating];
            _activityIndicator.hidden = YES;
            
            _fialImageView.hidden = NO;
            _statusContent.text = @"当前网络不可用";
            
        }
            break;
        case AFNetworkReachabilityStatusNotReachable:
            
            [_activityIndicator stopAnimating];
            _activityIndicator.hidden = YES;
            
            _fialImageView.hidden = NO;
            _statusContent.text = @"当前网络不可用";
            
            break;
        
        case AFNetworkReachabilityStatusReachableViaWWAN:
            
            _fialImageView.hidden = YES;
            _activityIndicator.hidden = NO;
            _statusContent.text = @"加载中....";
            [_activityIndicator startAnimating];

            break;
            
        case AFNetworkReachabilityStatusReachableViaWiFi:
            
            _fialImageView.hidden = YES;
            _activityIndicator.hidden = NO;
            _statusContent.text = @"加载中....";
            [_activityIndicator startAnimating];
            break;
            
        default:
            break;
    }
}

- (UILabel *)statusContent {
    
    if (!_statusContent) {
        
        _statusContent = [[UILabel alloc] init];
        _statusContent.textColor = AppFont666666Color;
        _statusContent.font = FONT(AppFont30Size);
        _statusContent.textAlignment = NSTextAlignmentCenter;
    }
    return _statusContent;
}

- (UIActivityIndicatorView *)activityIndicator {
    
    if (!_activityIndicator) {
        
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        //设置小菊花颜色
        _activityIndicator.color = AppFont999999Color;
        //设置背景颜色
        _activityIndicator.backgroundColor = AppFontf1f1f1Color;
        //刚进入这个界面会显示控件，并且停止旋转也会显示，只是没有在转动而已，没有设置或者设置为YES的时候，刚进入页面不会显示
        _activityIndicator.hidesWhenStopped = NO;
    }
    return _activityIndicator;
}

- (UIImageView *)fialImageView {
    
    if (!_fialImageView) {
        
        _fialImageView = [[UIImageView alloc] init];
        _fialImageView.image = IMAGE(@"networking_warning");
        _fialImageView.hidden = YES;
    }
    return _fialImageView;
}
@end

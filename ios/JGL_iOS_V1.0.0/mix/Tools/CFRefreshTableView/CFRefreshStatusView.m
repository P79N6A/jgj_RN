//
//  CFRefreshStatusView.m
//  RepairHelper
//
//  Created by coreyfu on 15/6/4.
//
//

#import "CFRefreshStatusView.h"
#import "UIView+GNUtil.h"

@interface CFRefreshStatusView ()

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIButton *actionBtn;
@property (nonatomic, strong) UIView *alertTitleView;
@property (nonatomic, strong)UIButton *alertActionBtn;
@end

@implementation CFRefreshStatusView

- (void)commonInit {
    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.tipsLabel = [[UILabel alloc] init];
    self.tipsLabel.font = [UIFont systemFontOfSize:AppFont34Size];
    self.tipsLabel.textColor = AppFontccccccColor;
    self.tipsLabel.numberOfLines = 0;
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    self.tipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    //self.actionBtn
    self.actionBtn = [[UIButton alloc] init];
    self.actionBtn.hidden = YES;
    self.actionBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont30Size];
    [self.actionBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.actionBtn.backgroundColor = AppFontd7252cColor;
    [self.actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.actionBtn.layer setLayerCornerRadius:5];

    [self addSubview:self.actionBtn];
    [self addSubview:self.imageView];
    [self addSubview:self.tipsLabel];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(105);
        make.size.mas_equalTo(CGSizeMake(90, 105 * 0.5));
    }];
    
    [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self.tipsLabel.mas_bottom).offset(24);
        make.size.mas_equalTo(CGSizeMake(120, 45));
    }];
    
    self.alertActionBtn = [[UIButton alloc] init];
    self.alertActionBtn.hidden = YES;
    [self.alertActionBtn addTarget:self action:@selector(handleAlertButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIView *alertTitleView = [[UIView alloc] init];
    self.alertTitleView = alertTitleView;
    alertTitleView.hidden = YES;
    alertTitleView.backgroundColor = AppFontd7252cColor;
    [self addSubview:alertTitleView];
    [self addSubview:self.alertActionBtn];
    
//    [self.alertActionBtn setImage:[UIImage imageNamed:@"Chat_notice_question_opacity"] forState:UIControlStateNormal];
//    self.alertActionBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 0, 0, 5);
    [self.alertActionBtn setTitle:@"同步的项目从哪儿来?" forState:UIControlStateNormal];
    self.alertActionBtn.titleLabel.font = [UIFont systemFontOfSize:AppFont26Size];
    [self.alertActionBtn setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];

    NSRange attributedRange = NSMakeRange(0, self.alertActionBtn.titleLabel.text.length);
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.alertActionBtn.titleLabel.text];
    
    [attributedStr addAttribute:NSStrokeColorAttributeName value:self.alertActionBtn.titleLabel.tintColor range:attributedRange];
    
    [self.alertActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        //        make.bottom.equalTo(self.mas_top).offset(50);
        make.size.mas_equalTo(CGSizeMake(130, 20));
        
        make.top.equalTo(self.imageView.mas_bottom).offset(15);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self.alertActionBtn.mas_bottom).offset(10);
    }];
    
    [alertTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.alertActionBtn.mas_left).offset(16);
        make.right.mas_equalTo(self.alertActionBtn.mas_right).offset(-13);
        make.top.mas_equalTo(self.alertActionBtn.mas_bottom);
        make.height.mas_equalTo(1.0);
    }];
}

- (void)setButtonTitle:(NSString *)buttonTitle {
    _buttonTitle = buttonTitle;;
    if (buttonTitle.length  > 0 && buttonTitle != nil) {
        [self.actionBtn setTitle:buttonTitle forState:UIControlStateNormal];
        self.actionBtn.hidden = NO;
    }
}

-(void)buttonPressed:(UIButton *)sender {

    if ([self.delegate respondsToSelector:@selector(cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:)]) {
        [self.delegate cfreRreshStatusViewButtonPressedWithcfreRreshStatusView:self];
    }
}

//处理底部警告按钮按下
- (void)handleAlertButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(handleAlertButtonAction:)]) {
        [self.delegate handleAlertButtonAction:self];
    }
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (CFRefreshStatusView *)initWithImage:(UIImage *)img withTips:(NSString *)tips {
    if (self = [super init]) {
        [self commonInit];
        self.imageView.image = img;
        self.tipsLabel.text = tips;
    }
    return self;
}

- (void)botttomButtonTilte:(NSString *)buttonTilte buttomImage:(NSString *)imageStr {
    self.alertActionBtn.hidden = NO;
    self.alertTitleView.hidden = NO;
    [self.alertActionBtn setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    [self.alertActionBtn setTitle:buttonTilte forState:UIControlStateNormal];
}

+ (CFRefreshStatusView *)defaultViewWithStatus:(ERefreshTableViewStatus)status{
    switch (status) {
        case RefreshTableViewStatusNormal:
            return nil;
        case RefreshTableViewStatusNoResult: {
            return [[self alloc] initWithImage:[UIImage imageNamed:@"NoData"] withTips:@"没有相关数据"];
        }
        case RefreshTableViewStatusNoNetwork: {
            return [[self alloc] initWithImage: [UIImage imageNamed:@"NoNetwork"] withTips:@"网络开小差啦!\n请检查你的手机网络设置"];
        }
        case RefreshTableViewStatusLoadError: {
            return [[self alloc] initWithImage: [UIImage imageNamed:@"LoadError"]withTips:@"出错啦，稍后再试试吧"];
        }
        default:
            return nil;
    }
}

- (void)setTextColor:(UIColor *)color{
    _textColor = color;
    [self.tipsLabel setTextColor:color];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


@end

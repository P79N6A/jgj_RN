//
//  JGJNewHomeVCTopView.m
//  mix
//
//  Created by Tony on 2019/3/4.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJNewHomeVCTopView.h"
#import "SJButton.h"
#import "JGJCommonButton.h"
#import "NSDate+Extend.h"

@interface JGJNewHomeVCTopView ()

@property (nonatomic, strong) SJButton *switIdentityBtn;// 切换身份按钮
@property (nonatomic, strong) UIButton *leftChangeBtn;
@property (nonatomic, strong) JGJCommonButton *makeANoteBtn;// 记事本


@end
@implementation JGJNewHomeVCTopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = AppFontEB4E4EColor;
        [self initializeAppearance];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = AppFontEB4E4EColor;
        [self initializeAppearance];
    }
    return self;
}

- (void)initializeAppearance {
    
    [self addSubview:self.switIdentityBtn];
    [self addSubview:self.leftChangeBtn];
    [self addSubview:self.dateLabel];
    [self addSubview:self.rightChangeBtn];
    [self addSubview:self.makeANoteBtn];
    [self setUpLayout];
    
    [self makeWeekTimeView];
    
    [_makeANoteBtn updateLayout];
    _makeANoteBtn.layer.cornerRadius = 14;
}

- (void)setUpLayout {
    
    [_makeANoteBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.width.mas_equalTo(70);
        make.top.mas_offset(5 + (IS_IPHONE_X_Later ? 44 : 20));
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(28);
    }];
    
    [_switIdentityBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(10);
        make.centerY.equalTo(_makeANoteBtn.mas_centerY).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_offset(0);
        make.centerY.equalTo(_makeANoteBtn.mas_centerY).offset(0);
        make.height.mas_equalTo(16);
    }];
    
    [_leftChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_makeANoteBtn.mas_centerY).offset(0);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
        make.right.equalTo(_dateLabel.mas_left).offset(-13);
        
    }];
    
    [_rightChangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(_makeANoteBtn.mas_centerY).offset(0);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(12);
        make.left.equalTo(_dateLabel.mas_right).offset(13);
        
    }];
    
}

- (void)makeWeekTimeView {
    
    CGFloat width = TYGetUIScreenWidth / 7;
    CGFloat height = 20;
    for (int i = 0; i < 7; i ++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = FONT(AppFont24Size);
        label.textAlignment = NSTextAlignmentCenter;
        switch (i) {
            case 0:
                label.text = @"日";
                label.textColor = [AppFontffffffColor colorWithAlphaComponent:0.5];
                break;
            case 1:
                
                label.text = @"一";
                label.textColor = AppFontffffffColor;
                break;
            case 2:
                
                label.text = @"二";
                label.textColor = AppFontffffffColor;
                break;
            case 3:
                
                label.text = @"三";
                label.textColor = AppFontffffffColor;
                break;
            case 4:
                
                label.text = @"四";
                label.textColor = AppFontffffffColor;
                break;
            case 5:
                
                label.text = @"五";
                label.textColor = AppFontffffffColor;
                break;
            case 6:
                
                label.text = @"六";
                label.textColor = [AppFontffffffColor colorWithAlphaComponent:0.5];
                break;
                
            default:
                break;
        }
        
        [self addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.mas_equalTo(i * width);
            make.bottom.mas_equalTo(-5);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(height);
        }];
    }
}

- (void)switIdentity {
    
    if (self.switIdentityBlock) {
        
        _switIdentityBlock();
    }
}

- (void)clickNoteBtn {
    
    if (self.makeANewNoteBlock) {
        
        _makeANewNoteBlock();
    }
}

- (void)leftChangeBtnClick {
    
    if (self.leftChoiceTimeBtnBlock) {
        
        _leftChoiceTimeBtnBlock();
    }
}

- (void)timeLabelClick {
    
    if (self.timeLabelChoiceBlock) {
        
        _timeLabelChoiceBlock();
    }
    
}

- (void)rightChangeBtnClick {
    
    if (self.rightChoiceTimeBtnBlock) {
        
        _rightChoiceTimeBtnBlock();
    }
}

//更新顶部信息

-(void)updateTopView {
    
    if (JLGisLeaderBool ) {
        
        [self.switIdentityBtn setTitle:@"我是班组长" forState:(SJControlStateNormal)];
        
    }else {
        
        [self.switIdentityBtn setTitle:@"我是工人" forState:(SJControlStateNormal)];
    }
    
}

- (SJButton *)switIdentityBtn {
    
    if (!_switIdentityBtn) {
        
        _switIdentityBtn = [SJButton buttonWithType:SJButtonTypeHorizontalImageTitle];
        [_switIdentityBtn setBackgroundColor:[UIColor clearColor]];
        [_switIdentityBtn setImage:IMAGE(@"change_role_icon") forState:SJControlStateNormal];
        if (JLGisLeaderBool ) {
            
            [_switIdentityBtn setTitle:@"我是班组长" forState:(SJControlStateNormal)];
            
        }else {
            
            [_switIdentityBtn setTitle:@"我是工人" forState:(SJControlStateNormal)];
        }
        
        [_switIdentityBtn setTitleColor:AppFontffffffColor forState:SJControlStateNormal];
        _switIdentityBtn.titleLabel.font = FONT(AppFont28Size);
        _switIdentityBtn.notNeedTheTrackingEffect = YES;
        _switIdentityBtn.imageViewW = 15;
        _switIdentityBtn.imageViewH = 15;
        _switIdentityBtn.space = 0;
        _switIdentityBtn.imageView.contentMode = UIViewContentModeCenter;
        [_switIdentityBtn addTarget:self action:@selector(switIdentity) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switIdentityBtn;
}

- (UIButton *)leftChangeBtn {
    
    if (!_leftChangeBtn) {
        
        _leftChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftChangeBtn setImage:IMAGE(@"home_top_left") forState:(UIControlStateNormal)];
        _leftChangeBtn.contentMode = UIViewContentModeRight;
        
        [_leftChangeBtn addTarget:self action:@selector(leftChangeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _leftChangeBtn;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        
        _dateLabel = [[UILabel alloc] init];
                
        NSString *dateStr = [NSDate stringFromDate:[NSDate date] format:@"yyyy年MM月"];
    
        _dateLabel.text = dateStr;
        _dateLabel.font = FONT(AppFont34Size);
        _dateLabel.textColor = AppFontffffffColor;
        _dateLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeLabelClick)];
        
        [_dateLabel addGestureRecognizer:gesture];
    }
    return _dateLabel;
}

- (UIButton *)rightChangeBtn {
    
    if (!_rightChangeBtn) {
        
        _rightChangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightChangeBtn setImage:IMAGE(@"home_top_right") forState:(UIControlStateNormal)];
        _rightChangeBtn.contentMode = UIViewContentModeLeft;
        [_rightChangeBtn addTarget:self action:@selector(rightChangeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
        _rightChangeBtn.hidden = YES;
    }
    return _rightChangeBtn;
}

- (JGJCommonButton *)makeANoteBtn {
    
    if (!_makeANoteBtn) {
        
        _makeANoteBtn = [JGJCommonButton buttonWithType:UIButtonTypeCustom];
        [_makeANoteBtn setBackgroundImage:IMAGE(@"makeNoteRecordBtn") forState:(UIControlStateNormal)];
        [_makeANoteBtn setTitleColor:AppFontEB4E4EColor forState:(UIControlStateNormal)];
        _makeANoteBtn.adjustsImageWhenHighlighted = NO;
        _makeANoteBtn.titleLabel.font = FONT(AppFont30Size);
        _makeANoteBtn.clipsToBounds = YES;
        [_makeANoteBtn addTarget:self action:@selector(clickNoteBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _makeANoteBtn;
}

@end

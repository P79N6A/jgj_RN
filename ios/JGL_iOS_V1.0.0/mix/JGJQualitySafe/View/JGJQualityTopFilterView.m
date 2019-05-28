//
//  JGJQualityTopFilterView.m
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityTopFilterView.h"
#import "NSString+Extend.h"
@interface JGJQualityTopFilterView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *bottomLineView;

@property (weak, nonatomic) UIButton *lastButton; //上次选择的按钮

@property (weak, nonatomic) IBOutlet UIButton *allButton;

@property (weak, nonatomic) IBOutlet UIButton *cusFilterButton;

//质量问题和质量检查共用一个
@property (weak, nonatomic) IBOutlet UIView *waitMeModifyFlag;

//质量检查时当前表示隐藏
@property (weak, nonatomic) IBOutlet UIView *waitMeReviewFlag;

@end

@implementation JGJQualityTopFilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
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

-(void)awakeFromNib {

    [super awakeFromNib];
    
    for (UIView *subView in self.contentView.subviews) {
        
        for (UIButton *btn in subView.subviews) {
            
            if ([btn isKindOfClass:[UIButton class]] && btn.tag > 0) {
                
                [btn setTitleColor:AppFont666666Color forState:UIControlStateNormal];
                
                //全部筛选
                if (btn.tag == 100) {
                    
                    btn.selected = YES;
                    
                    self.lastButton = btn;
                    
                    if (btn.selected) {
                        
                        [self.allButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
                    }
                }
                
            }
        }
        
    }
    
    [self.cusFilterButton setTitleColor:AppFont333333Color forState:UIControlStateNormal];
    
    [self.waitMeModifyFlag.layer setLayerCornerRadius:JGJRedFlagWH / 2.0];
    
    [self.waitMeReviewFlag.layer setLayerCornerRadius:JGJRedFlagWH / 2.0];

    self.waitMeModifyFlag.backgroundColor = AppFontFF0000Color;
    
    self.waitMeReviewFlag.backgroundColor = AppFontFF0000Color;
}

- (void)setupView {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJQualityTopFilterView" owner:self options:nil] lastObject];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    self.bottomLineView.backgroundColor = AppFontf1f1f1Color;
    
    self.allButton.selected = YES;
    
    if (self.allButton.selected) {
        
        [self.allButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    }
    
    self.lastButton = self.allButton;
    
    self.waitMeModifyFlag.hidden = YES;
    
    self.waitMeReviewFlag.hidden = YES;
    
}

- (void)layoutSubviews {

    [super layoutSubviews];
    
}

- (void)setLastFilterType:(TopFilterViewType)lastFilterType {

    _lastFilterType = lastFilterType;
    
}

- (IBAction)handeButtonPressed:(UIButton *)sender {
    
    //质量检查类型时，有一个是空的类型点击无效
    if ((self.lastButton.tag == sender.tag && self.lastButton.selected) || [NSString isEmpty:sender.titleLabel.text]) {
        
        return;
    }
    
    self.lastButton.selected = NO;
    
    if (!self.lastButton.selected) {
        
        [self.lastButton setTitleColor:AppFont666666Color forState:UIControlStateNormal];
        
    }
    
    sender.selected = YES;
    
    if (sender.selected) {
        
        [sender setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
    }
    
    self.lastButton = sender;
    
    TopFilterViewType type = sender.tag - 100;
    
    if (self.topFilterViewBlock) {
        
        self.topFilterViewBlock(type);
    }
    
}

- (void)setTopFilterViewCusCheckType:(TopFilterViewCusCheckType)topFilterViewCusCheckType {

    _topFilterViewCusCheckType = topFilterViewCusCheckType;
    
    self.waitMeReviewFlag.hidden = YES;
    
    NSArray *buttonTitles = @[@"全部", @"待检查", @"已完成", @"我提交的",@"待我检查", @"", @"筛选"];
    
    for (UIView *subView in self.contentView.subviews) {
        
        for (UIButton *btn in subView.subviews) {
            
            if ([btn isKindOfClass:[UIButton class]] && btn.tag > 0) {
                
                NSInteger index = btn.tag - 100;
                
                //当前是检查的情况
                if (self.topFilterViewCusCheckType == TopFilterViewCheckType) {
                    
                    NSString *buttontitle = buttonTitles[index];
                    
                    [btn setTitle:buttontitle forState:UIControlStateNormal];
                }
            }
        }
        
    }

}

- (void)setQualitySafeModel:(JGJQualitySafeModel *)qualitySafeModel {

    _qualitySafeModel = qualitySafeModel;
    
    for (UIView *subView in self.contentView.subviews) {
        
        for (UIButton *btn in subView.subviews) {
            
            if ([btn isKindOfClass:[UIButton class]] && btn.tag > 0) {
                
                NSInteger index = btn.tag - 100;
                
                if (btn.tag == 104) {
                    
                    if ([_qualitySafeModel.rect_me_red isEqualToString:@"1"]) {
                        
                        self.waitMeModifyFlag.hidden = NO;
                        
                    }else {
                        
                        self.waitMeModifyFlag.hidden = YES;
                    }
                }else if (btn.tag == 105) {
                
                    if ([_qualitySafeModel.check_me_red isEqualToString:@"1"]) {
                        
                        self.waitMeReviewFlag.hidden = NO;
                        
                    }else {
                        
                        self.waitMeReviewFlag.hidden = YES;
                    }
                }
                
                NSString *buttontitle = _qualitySafeModel.filterCounts[index];
                
                [btn setTitle:buttontitle forState:UIControlStateNormal];

            }
        }
        
    }

}

- (void)setQuaSafeCheckModel:(JGJQuaSafeCheckModel *)quaSafeCheckModel {

    _quaSafeCheckModel = quaSafeCheckModel;
    
    for (UIView *subView in self.contentView.subviews) {
        
        for (UIButton *btn in subView.subviews) {
            
            if ([btn isKindOfClass:[UIButton class]] && btn.tag > 0) {
                
                NSInteger index = btn.tag - 100;
                
                NSString *buttontitle = _quaSafeCheckModel.checkFilterCounts[index];
                
                //最后一个空白不显示
                self.waitMeReviewFlag.hidden = btn.tag == 105;
                
                if (btn.tag == 104) {
                    
                    if ([quaSafeCheckModel.check_me_red isEqualToString:@"1"]) {
                        
                        self.waitMeModifyFlag.hidden = NO;
                        
                    }else {
                    
                        self.waitMeModifyFlag.hidden = YES;
                    }
                }
                
                [btn setTitle:buttontitle forState:UIControlStateNormal];
                
            }
        }
        
    }

}

- (IBAction)customFilterButtonPressed:(UIButton *)sender {
    
    if (self.topFilterViewBlock) {
        
        self.topFilterViewBlock(TopFilterViewCusModifyType);
    }
}

+ (instancetype)qualityTopFilterView{

    return [[[NSBundle mainBundle] loadNibNamed:@"JGJQualityTopFilterView" owner:self options:nil] lastObject];
}

@end

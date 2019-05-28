//
//  YZGNoWorkitemsView.m
//  mix
//
//  Created by Tony on 16/3/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGNoWorkitemsView.h"
#import "UILabel+GNUtil.h"

@interface YZGNoWorkitemsView ()

@end

@implementation YZGNoWorkitemsView

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

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    self.contentView.frame = self.bounds;
    [self addSubview:self.contentView];
    [self.noRecordButton.layer setLayerCornerRadiusWithRatio:0.05];
    self.noRecordButton.backgroundColor = JGJMainColor;
    self.backButton.hidden = YES;
    self.contentView.backgroundColor = AppFontf1f1f1Color;
}
-(void)setContentStr:(NSString *)content
{
    if (![NSString isEmpty: content]) {
        self.noRecordLabel.text = content;
        self.noRecordLabel.textColor = AppFont999999Color;
    }
}
- (void)setTitleString:(id)titleString subString:(id)subString{
    if ([titleString isKindOfClass:[NSString class]]) {
        self.noRecordLabel.text = titleString;
    }else{//富文本
        NSAttributedString *attributedString = titleString;
        self.noRecordLabel.text = attributedString.string;
        self.noRecordLabel.textColor = AppFont999999Color;
        self.noRecordLabel.font = [UIFont systemFontOfSize:AppFont34Size];
        [self.noRecordLabel markLineText:subString withLineFont:[UIFont systemFontOfSize:AppFont26Size] withColor:AppFontccccccColor lineSpace:9];
    }
}

- (void)setTitleString:(id)titleString{
    if ([titleString isKindOfClass:[NSString class]]) {
        
        self.noRecordLabel.text = titleString;
    }else{
        
        self.noRecordLabel.attributedText = titleString;
    }
}

- (void)setButtonShow:(BOOL )isShow{
    self.noRecordButton.hidden = !isShow;
}

- (void)setButtonString:(NSString *)buttonTitle{
    self.noRecordButton.hidden = NO;
    [self.noRecordButton setTitle:buttonTitle forState:UIControlStateNormal];
}

- (IBAction)buttonBtnClick:(id)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(YZGNoWorkitemsViewBtnClick:)]) {
        [self.delegate YZGNoWorkitemsViewBtnClick:self];
    }
}

- (void)showNoWorkitemsView{
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self.contentView layoutIfNeeded];
    }
}

- (void)hiddenNoWorkitemsView {
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self removeFromSuperview];
    }
}

- (void)dealloc{
    [self hiddenNoWorkitemsView];
}
@end

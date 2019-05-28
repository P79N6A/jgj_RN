//
//  JGJPublishLogButton.m
//  JGJCompany
//
//  Created by Tony on 2017/7/14.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPublishLogButton.h"

@implementation JGJPublishLogButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initView];

}
- (IBAction)clickChoiceButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickChoiceTemplateLogButton)]) {
        [self.delegate clickChoiceTemplateLogButton];
    }
}
- (IBAction)clickPublishButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickChoicePublsihLogButton)]) {
        [self.delegate clickChoicePublsihLogButton];
    }
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initView];

    }
    
    return self;
}
- (void)initView{
    [[[NSBundle mainBundle]loadNibNamed:@"JGJPublishLogButton" owner:self options:nil]lastObject];
    [self.contentView setFrame:self.bounds];
    [self addSubview:self.contentView];
    self.choiceLogButton.layer.masksToBounds = YES;
    self.choiceLogButton.layer.cornerRadius = JGJCornerRadius;
    self.choiceLogButton.layer.borderColor = AppFontEB4E4EColor.CGColor;
    self.choiceLogButton.layer.borderWidth = 0.7;
    
    self.publishLogButton.layer.masksToBounds = YES;
    self.publishLogButton.layer.cornerRadius = JGJCornerRadius;


}
@end

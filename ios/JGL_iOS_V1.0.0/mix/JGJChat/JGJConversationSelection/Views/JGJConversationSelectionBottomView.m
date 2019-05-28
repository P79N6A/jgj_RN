//
//  JGJConversationSelectionBottomView.m
//  mix
//
//  Created by Json on 2019/3/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJConversationSelectionBottomView.h"
@interface JGJConversationSelectionBottomView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *ensureButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation JGJConversationSelectionBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.lineView.backgroundColor = AppFontdbdbdbColor;
    
    self.titleLabel.text = @"已选择";
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    self.titleLabel.textColor = AppFont666666Color;
    
    self.contentLabel.font = [UIFont systemFontOfSize:14];
    self.contentLabel.text = nil;
    
    self.ensureButton.backgroundColor = AppFontccccccColor;
    self.ensureButton.userInteractionEnabled = NO;
    
    self.ensureButton.layer.cornerRadius = 5;
    self.ensureButton.clipsToBounds = YES;
    [self.ensureButton setTitleColor:AppFontffffffColor forState:(UIControlStateNormal)];
    [self.ensureButton setTitle:@"确定" forState:(UIControlStateNormal)];
    self.ensureButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.ensureButton addTarget:self action:@selector(ensureButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
}
+ (instancetype)bottomView {
    JGJConversationSelectionBottomView *bottomView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil]lastObject];
    return bottomView;
}

- (void)setContent:(NSString *)content
{
    _content = [content copy];
    self.contentLabel.text = content;
}

- (void)setButtonEnable:(BOOL)buttonEnable
{
    _buttonEnable = buttonEnable;
    self.ensureButton.userInteractionEnabled = buttonEnable;
    self.ensureButton.backgroundColor = buttonEnable ? AppFontEB4E4EColor : AppFontccccccColor;
}

- (void)ensureButtonClicked
{
    if (self.ensureAction) {
        self.ensureAction();
    }
}



@end

//
//  JLGSendProjectTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGSendProjectTableViewCell.h"
#import "CALayer+SetLayer.h"

@interface JLGSendProjectTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *sendProjectButton;
@end

@implementation JLGSendProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.sendProjectButton.layer setLayerCornerRadius:4.0];
    self.sendProjectButton.backgroundColor = JGJMainColor;
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    if (self.titleString) {
        [self.sendProjectButton setTitle:self.titleString forState:UIControlStateNormal];
    }
}
- (void)setSendButtonTitle:(NSString *)title titleColor:(UIColor *)titleColor backGroudcolor:(UIColor *)backgroundColor {
    self.sendProjectButton.backgroundColor = backgroundColor;
    [self.sendProjectButton setTitleColor:titleColor forState:UIControlStateNormal];
}
- (void)setBackColor:(UIColor *)backColor{
    _backColor = backColor;
    self.contentView.backgroundColor = backColor;
}


- (IBAction)sendProjectCellBtnClick:(UIButton *)sender {
    if([self.delegate respondsToSelector:@selector(sendProjectCellBtnClick)]){
        [self.delegate sendProjectCellBtnClick];
    }
}
@end

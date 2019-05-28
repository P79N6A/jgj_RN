//
//  YZGWageMoreDetailViewTableViewCell.m
//  mix
//
//  Created by Tony on 16/3/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGWageMoreDetailViewTableViewCell.h"

@interface YZGWageMoreDetailViewTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *yearMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *oweMoneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;

@end

@implementation YZGWageMoreDetailViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.oweMoneyLabel.layer setLayerCornerRadiusWithRatio:0.05];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setYearMonthText:(NSString *)yearMonthText money:(CGFloat )money{
    self.yearMonthLabel.text = yearMonthText;
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",money];
    
    if (money < 0) {
        self.oweMoneyLabel.hidden = NO;
        self.moneyLabel.textColor = TYColorHex(0x92c977);
    }else{
        self.oweMoneyLabel.hidden = YES;
        self.moneyLabel.textColor = JGJMainColor;
    }
}

-(void)setRightButtonText:(NSString *)buttonText{
    if (!buttonText) {
        self.rightImage.hidden = YES;
        self.rightButton.hidden = YES;
        return;
    }
    
    self.rightImage.hidden = NO;
    self.rightButton.hidden = NO;
    self.rightImage.transform = CGAffineTransformMakeRotation(0);
    [self.rightButton setTitle:buttonText forState:UIControlStateNormal];
}

- (IBAction)rightButtonBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(WageMoreDetailCellRightBtnClik:)]) {
        [self.delegate WageMoreDetailCellRightBtnClik:self];
    }

}

- (void)rigthImageTransFormUp{
    [UIView animateWithDuration:0.2 animations:^{
        self.rightImage.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)rigthImageTransFormReset{
    self.rightImage.transform = CGAffineTransformMakeRotation(0);
}

@end

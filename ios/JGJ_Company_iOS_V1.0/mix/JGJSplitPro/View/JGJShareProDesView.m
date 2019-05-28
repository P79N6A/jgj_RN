//
//  JGJShareProDesView.m
//  JGJCompany
//
//  Created by yj on 16/9/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJShareProDesView.h"
#import "UILabel+GNUtil.h"
static JGJShareProDesView *_proDesView;
@interface JGJShareProDesView ()
@property (weak, nonatomic) IBOutlet UILabel *popTitleLable;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIImageView *exampleImageView;
@property (weak, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewH;
@end

@implementation JGJShareProDesView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.confirmButton.backgroundColor = AppFontd7252cColor;
    self.popTitleLable.font = [UIFont systemFontOfSize:AppFont34Size];
    self.popDetailLable.font = [UIFont systemFontOfSize:AppFont26Size];
    self.popTitleLable.textColor = AppFont666666Color;
    self.popDetailLable.textColor = AppFont999999Color;
    self.popDetailLable.textAlignment = NSTextAlignmentLeft;
    self.containView.backgroundColor = [UIColor whiteColor];
    [self.containView.layer setLayerCornerRadius:JGJCornerRadius];
}

+ (JGJShareProDesView *)shareProDesViewWithProDesModel:(JGJShareProDesModel *)proDesModel {
    _proDesView = [[[NSBundle mainBundle] loadNibNamed:@"JGJShareProDesView" owner:self options:nil] lastObject];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    _proDesView.frame = window.bounds;
    [_proDesView removeFromSuperview];
    [window addSubview:_proDesView];
    _proDesView.popTitleLable.text = proDesModel.popTitle;
    _proDesView.popDetailLable.text = proDesModel.popDetail;
    _proDesView.exampleImageView.image = [UIImage imageNamed:proDesModel.icon];
//    _proDesView.containViewH.constant = proDesModel.isSplitDes ? 305 : 405;
    _proDesView.containViewH.constant = proDesModel.contentViewHeight;
    [_proDesView.popDetailLable setAttributedText:proDesModel.popDetail lineSapcing:3];
    return _proDesView;
}

- (IBAction)handleConfirmButtonPressed:(UIButton *)sender {
    [self dismiss];
}
- (void)dismiss{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        _proDesView.transform = CGAffineTransformScale(_proDesView.transform,0.9,0.9);
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}
@end

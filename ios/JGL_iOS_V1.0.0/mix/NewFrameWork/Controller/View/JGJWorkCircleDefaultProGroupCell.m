//
//  JGJWorkCircleDefaultProGroupCell.m
//  mix
//
//  Created by Tony on 2016/8/18.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleDefaultProGroupCell.h"
#import "UILabel+GNUtil.h"
#import "UIView+GNUtil.h"

@interface JGJWorkCircleDefaultProGroupCell ()

@property (weak, nonatomic) IBOutlet UIButton *createGroupButton;

@property (weak, nonatomic) IBOutlet UIButton *scanQRCodeButton;

@property (weak, nonatomic) IBOutlet UIView *contentSubView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSubViewW;

@end

@implementation JGJWorkCircleDefaultProGroupCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self commonSet];
    
}

- (void)commonSet {
    
    [self.contentSubView.layer setLayerBorderWithColor:AppFontfafafaColor width:1 radius:JGJCornerRadius];
    
    self.contentSubView.layer.masksToBounds = YES;
    
    [self.scanQRCodeButton.layer setLayerBorderWithColor:AppFont666666Color width:1 radius:5];
    
    [self.createGroupButton.layer setLayerBorderWithColor:AppFont666666Color width:1 radius:5];
    
    self.contentSubViewW.constant = TYGetUIScreenWidth;
}

- (IBAction)createGroupBtnClick:(UIButton *)sender {

    if (self.delegate && [self.delegate respondsToSelector:@selector(defaultGroupBtnClick:clickType:)]) {
        [self.delegate defaultGroupBtnClick:self clickType:WorkCircleHeaderViewCreatGroupButtonType];
    }
}

- (IBAction)scanQRCodeBtnClick:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(defaultGroupBtnClick:clickType:)]) {
        [self.delegate defaultGroupBtnClick:self clickType:WorkCircleHeaderViewCreatSweepQrCodeButtonType];
    }
}


+ (CGFloat)defaultCreatProCellHeight {
    
    return 0.23 * TYGetUIScreenHeight;
    
}

@end

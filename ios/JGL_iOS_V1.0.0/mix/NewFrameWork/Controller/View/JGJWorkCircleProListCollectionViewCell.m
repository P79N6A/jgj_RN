//
//  JGJWorkCircleProListCollectionViewCell.m
//  JGJCompany
//
//  Created by yj on 17/3/31.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleProListCollectionViewCell.h"

@interface JGJWorkCircleProListCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *titleButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLable;
@property (weak, nonatomic) IBOutlet UIView *msgFlagView;

@property (strong, nonatomic) NSArray *infoModels;//存储首页信息模型数组

@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleButtonW;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleButtonH;

@end

@implementation JGJWorkCircleProListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.msgFlagView.layer setLayerCornerRadius:TYGetViewH(self.msgFlagView) / 2.0];
    
    self.msgFlagView.backgroundColor = TYColorHex(0xFF0000);
    self.titleLable.textColor = [UIColor blackColor];
    
    CGFloat titleButtonWH = 33.0;
    
    self.titleLable.font = [UIFont systemFontOfSize:AppFont26Size];
    
    if (TYIS_IPHONE_6P) {
        
        titleButtonWH = 33.0;
        
        self.titleLable.font = [UIFont systemFontOfSize:AppFont28Size];
        
    }
    
    self.titleButtonH.constant = titleButtonWH;
    
    self.titleButtonW.constant = titleButtonWH;
}

- (void)setInfoModel:(JGJWorkCircleMiddleInfoModel *)infoModel {
    _infoModel = infoModel;
    
//    [self.titleButton setImage:[UIImage imageNamed:_infoModel.InfoImageIcon] forState:UIControlStateNormal];
    self.typeImageView.image = [UIImage imageNamed:_infoModel.InfoImageIcon];
    self.typeImageView.contentMode = UIViewContentModeCenter;
    self.titleLable.text = _infoModel.desc;
    
    self.msgFlagView.hidden = _infoModel.isHiddenUnReadMsgFlag;
    
    self.typeImageView.alpha = infoModel.isHightlight ? 0.5 : 1.0;
}

- (IBAction)handleButtonPressedAction:(UIButton *)sender {
        
    if ([self.delegate respondsToSelector:@selector(workCircleProListCollectionViewCell:didSelectedType:)]) {
        
        [self.delegate workCircleProListCollectionViewCell:self didSelectedType:self.infoModel];
    }
}





@end

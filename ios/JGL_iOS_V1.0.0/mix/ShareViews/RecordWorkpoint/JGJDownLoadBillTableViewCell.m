//
//  JGJDownLoadBillTableViewCell.m
//  mix
//
//  Created by Tony on 2016/7/5.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJDownLoadBillTableViewCell.h"
#import "CALayer+SetLayer.h"

@implementation DownLoadBillModel
@end

@interface JGJDownLoadBillTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *downBillButton;

@end

@implementation JGJDownLoadBillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.downBillButton.layer setLayerBorderWithColor:TYColorHex(0x666666) width:0.6 ration:0.02];
    
}

- (void)setDownLoadBillModel:(DownLoadBillModel *)downLoadBillModel{
    _downLoadBillModel = downLoadBillModel;
    
    [self.downBillButton setTitle:[NSString stringWithFormat:@"保存%@月账单到手机",@(downLoadBillModel.month)] forState:UIControlStateNormal];
    [self.downBillButton layoutIfNeeded];
}
- (IBAction)downBillBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DownBillBtnClick:)]) {
        [self.delegate DownBillBtnClick:self];
    }
}

@end

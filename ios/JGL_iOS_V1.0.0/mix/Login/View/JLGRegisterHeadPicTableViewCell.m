//
//  JLGRegisterHeadPicTableViewCell.m
//  mix
//
//  Created by Tony on 16/1/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGRegisterHeadPicTableViewCell.h"

@interface  JLGRegisterHeadPicTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *headImageButton;
@property (weak, nonatomic) IBOutlet UILabel *headImageLabel;

@end

@implementation JLGRegisterHeadPicTableViewCell

- (void)setHeadImage:(UIImage *)headImage{
    _headImage = headImage;
    [self.headImageButton setImage:headImage forState:UIControlStateNormal];

    self.headImageLabel.hidden = headImage;
}

- (IBAction)upHeadPicBtnClick:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(JLGRegisterHeadPicBtnClick)]) {
        [self.delegate JLGRegisterHeadPicBtnClick];
    }
}
@end

//
//  JGJTaskfromCollectionViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/6/7.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJTaskfromCollectionViewCell.h"

@implementation JGJTaskfromCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.reciveButton setImage:[UIImage imageNamed:@"待处理"] forState:UIControlStateNormal];
    [self.reciveButton setTitle:@"待处理" forState:UIControlStateNormal];
    // Initialization code
}
-(void)setHadClick:(NSString *)hadClick
{
    
    if ([[NSString stringWithFormat:@"%@",hadClick] isEqualToString:@"1"]) {
        [self.reciveButton setImage:[UIImage imageNamed:@"reciveImage"] forState:UIControlStateNormal];
        [self.reciveButton setTitle:@"已收到" forState:UIControlStateNormal];
        [self.reciveButton setTitleColor:AppFontccccccColor forState:UIControlStateNormal];
        self.reciveButton.userInteractionEnabled = NO;
        self.reciveButton.layer.borderWidth = 0.5;
        self.reciveButton.layer.borderColor = AppFontdbdbdbColor.CGColor;
        
    }else{
        
        
    }
    
}

@end

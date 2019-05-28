//
//  JGJQuanQCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/4/18.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQuanQCollectionViewCell.h"

@implementation JGJQuanQCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _QuanLable = [[UILabel alloc]initWithFrame:CGRectMake((TYGetUIScreenWidth - 50 )/ 5 - 15, 0, 15, 15)];
    _QuanLable.backgroundColor = [UIColor whiteColor];
//    _QuanLable.layer.masksToBounds = YES;
    _QuanLable.layer.cornerRadius = CGRectGetWidth(_QuanLable.frame)/2;
    _QuanLable.layer.borderWidth = 1;
    _QuanLable.font = [UIFont systemFontOfSize:11];
    _QuanLable.textAlignment = NSTextAlignmentCenter;
    _QuanLable.textColor = AppFont999999Color;
    _QuanLable.layer.borderColor = AppFontccccccColor.CGColor;
    _QuanLable.hidden = YES;
    [self.contentView addSubview:_QuanLable];
}

@end

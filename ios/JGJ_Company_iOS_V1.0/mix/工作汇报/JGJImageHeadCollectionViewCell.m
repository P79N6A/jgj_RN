//
//  JGJImageHeadCollectionViewCell.m
//  JGJCompany
//
//  Created by Tony on 2017/5/23.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJImageHeadCollectionViewCell.h"

@implementation JGJImageHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 5;
}

@end

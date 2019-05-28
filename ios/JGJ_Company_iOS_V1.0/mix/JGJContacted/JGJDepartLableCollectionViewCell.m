//
//  JGJDepartLableCollectionViewCell.m
//  mix
//
//  Created by Tony on 2017/1/6.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJDepartLableCollectionViewCell.h"

@implementation JGJDepartLableCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setColor:(UIColor *)color
{

    [_departLable setBackgroundColor:color];
}
@end

//
//  JLGProjectCollectionViewCell.m
//  mix
//
//  Created by jizhi on 15/12/9.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGProjectCollectionViewCell.h"

@implementation JLGProjectCollectionViewCell

-(void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self.backButton.layer setLayerBorderWithColor:AppFontccccccColor width:0.5 radius:5];
    
}

@end

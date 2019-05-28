//
//  JGJTabFooterView.m
//  mix
//
//  Created by yj on 2018/3/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJTabFooterView.h"

#import "CustomView.h"

@implementation JGJFooterViewInfoModel


@end

@interface JGJTabFooterView ()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *tips;

@property (weak, nonatomic) IBOutlet LineView *leftLineView;

@property (weak, nonatomic) IBOutlet LineView *rightLineView;

@end

@implementation JGJTabFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonSet];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self commonSet];
    }
    
    return self;
    
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJTabFooterView" owner:self options:nil] lastObject];
    
    self.contentView.frame = self.bounds;
    
    [self addSubview:self.contentView];
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    self.tips.textColor = AppFont999999Color;
    
    self.tips.font = [UIFont systemFontOfSize:AppFont24Size];
    
}

- (void)setFooterInfoModel:(JGJFooterViewInfoModel *)footerInfoModel {
    
    _footerInfoModel = footerInfoModel;
    
    self.tips.textColor = footerInfoModel.textColor;
    
    self.contentView.backgroundColor = footerInfoModel.backColor;
    
    NSString *des = @"别拉了，没有更多啦";
    
    switch (footerInfoModel.desType) {
            
        case UITableViewFooterDefaultType:
            
            break;
            
        case UITableViewFooterFirstType:{
            
            des = @"朋友多了路好走";
        }
            
            break;
            
        case UITableViewFooterSecType:
            
            break;
            
        default:
            break;
    }
    
    self.tips.text = des;
    
    self.leftLineView.hidden = footerInfoModel.isHiddenLine;
    
    self.rightLineView.hidden = footerInfoModel.isHiddenLine;
}


@end

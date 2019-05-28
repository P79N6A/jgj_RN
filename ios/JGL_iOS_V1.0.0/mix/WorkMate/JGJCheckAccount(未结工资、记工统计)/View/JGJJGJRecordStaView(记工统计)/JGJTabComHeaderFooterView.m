//
//  JGJTabComHeaderFooterView.m
//  mix
//
//  Created by yj on 2018/7/3.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJTabComHeaderFooterView.h"

#import "UILabel+GNUtil.h"

@implementation JGJTabComHeaderFooterViewModel


@end

@interface JGJTabComHeaderFooterView ()

@property (strong, nonatomic) IBOutlet UIView *containView;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *des;

@end

@implementation JGJTabComHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self commonSet];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self commonSet];
        
    }
    
    return self;
}

- (void)commonSet {
    
    [[[NSBundle mainBundle] loadNibNamed:@"JGJTabComHeaderFooterView" owner:self options:nil] lastObject];
    
    self.containView.backgroundColor = AppFontf1f1f1Color;
    
    self.containView.frame = self.bounds;
    
    [self addSubview:self.containView];
    
    self.title.textColor = AppFont999999Color;
    
    self.des.textColor = AppFont999999Color;
    
    self.containView.backgroundColor = AppFontEBEBEBColor;
    
    self.title.font = [UIFont systemFontOfSize:AppFont26Size];
    
    self.des.font = [UIFont systemFontOfSize:AppFont26Size];
    
}

- (void)setInfoModel:(JGJTabComHeaderFooterViewModel *)infoModel {
    
    _infoModel = infoModel;
    
    self.title.text = infoModel.title;
    
    self.des.text = infoModel.des;
    
    if (![NSString isEmpty:infoModel.changeColorStr]) {
        
        [self.des markText:infoModel.changeColorStr withColor:AppFont333333Color];
        
    }
    
    if (infoModel.titleColor) {
        
        self.title.textColor = infoModel.titleColor;
    }
    
    if (infoModel.desColor) {
        
        self.des.textColor = infoModel.desColor;
    }
    
}

@end

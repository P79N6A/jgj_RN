//
//  JGJQualityDetailContentCell.m
//  mix
//
//  Created by yj on 2017/6/8.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJQualityDetailContentCell.h"

#import "NSString+Extend.h"

#import "UILabel+JGJCopyLable.h"

#import "UILabel+GNUtil.h"

#import "JGJCoreTextLable.h"

@interface JGJQualityDetailContentCell ()

@property (weak, nonatomic) IBOutlet JGJCoreTextLable *contentLable;

@property (weak, nonatomic) IBOutlet JGJCoreTextLable *backColorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backColorViewW;

@end

@implementation JGJQualityDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentLable.textColor = AppFont333333Color;
    
    self.contentLable.preferredMaxLayoutWidth = TYGetUIScreenWidth - 20;
    
    self.contentLable.font = [UIFont systemFontOfSize:AppFont30Size];
    
    //使用复制功能
    self.contentLable.isCanCopy = YES;
    
    self.contentLable.lineBreakMode = NSLineBreakByWordWrapping;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHideCallback) name:UIMenuControllerDidHideMenuNotification object:nil];
    
    TYWeakSelf(self);
    
    self.contentLable.copyBlock = ^{
      
        [weakself menuDidShowCallback];
    };
}

- (void)setQualityDetailModel:(JGJQualityDetailModel *)qualityDetailModel {

    _qualityDetailModel = qualityDetailModel;
    
    if (![NSString isEmpty:_qualityDetailModel.msg_text]) {
        
        self.contentLable.text = _qualityDetailModel.msg_text;
        
        self.contentLable.lineSpace = 5.0;
        
        [self.contentLable setContentTextlinkAttCoreTextModel:nil contentText:_qualityDetailModel.msg_text];

//这里在10.3计算不准确，但是可以设置间距
        CGFloat height = [self.contentLable stringWithContentWidth:TYGetUIScreenWidth - 20 font:AppFont30Size lineSpace:5 changeStr:nil changeColor:AppFont999999Color];
        
        height = [NSString stringWithContentWidth:TYGetUIScreenWidth - 20 content:self.contentLable.text font: AppFont30Size lineSpace:5];
        
        _qualityDetailModel.cellHeight =  [NSString isEmpty:_qualityDetailModel.msg_text] ? CGFLOAT_MIN : height + 16;
        
        self.backColorViewW.constant = [self.contentLable sizeThatFits:CGSizeMake(TYGetUIScreenWidth - 20, CGFLOAT_MAX)].width + 3;
        
        
    }

}

- (void)menuDidHideCallback{
    
    self.backColorView.hidden = YES;
    
    self.backColorView.backgroundColor = AppFontffffffColor;
    
}

- (void)menuDidShowCallback {
    
    self.backColorView.hidden = NO;
    
    self.backColorView.backgroundColor = AppFontccccccColor;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

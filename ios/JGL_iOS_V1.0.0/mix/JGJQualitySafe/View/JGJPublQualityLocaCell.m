//
//  JGJPublQualityLocaCell.m
//  mix
//
//  Created by YJ on 17/6/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPublQualityLocaCell.h"

#import "UILabel+GNUtil.h"

#import "NSString+Extend.h"

@interface JGJPublQualityLocaCell ()
@property (weak, nonatomic) IBOutlet UILabel *locationLable;

@end

@implementation JGJPublQualityLocaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.locationLable.textColor = AppFont333333Color;
}

- (void)setLocationModel:(JGJQualityLocationModel *)locationModel {

    _locationModel = locationModel;
    
    self.locationLable.text = locationModel.text;
    
    if (![NSString isEmpty:self.searchValue]) {
        [self.locationLable markattributedTextArray:@[self.searchValue] color:AppFontEF272FColor font:self.locationLable.font isGetAllText:YES];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

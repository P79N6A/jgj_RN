//
//  YZGCityCell.m
//  mix
//
//  Created by yj on 16/4/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJCityCell.h"

@interface JGJCityCell ()

@property (weak, nonatomic) IBOutlet UILabel *cityLable;

@end

@implementation JGJCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cityLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.cityLable.textColor = AppFont333333Color;
    self.contentView.backgroundColor = AppFontfafafaColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor = !highlighted ? AppFontf3f3f3Color : [UIColor whiteColor];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {

    static NSString *ID = @"Cell";
    JGJCityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJCityCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setCityModel:(JLGCityModel *)cityModel {

    _cityModel = cityModel;
    self.cityLable.text = cityModel.city_name;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  YZGProvinceCell.m
//  mix
//
//  Created by yj on 16/4/13.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJProvinceCell.h"

@interface JGJProvinceCell ()
@property (weak, nonatomic) IBOutlet UILabel *provinceLable;

@end

@implementation JGJProvinceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.provinceLable.font = [UIFont systemFontOfSize:AppFont30Size];
    self.provinceLable.textColor = AppFont666666Color;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"Cell";
    JGJProvinceCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJProvinceCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setCityModel:(JLGCityModel *)cityModel {
    
    _cityModel = cityModel;
    self.provinceLable.text = cityModel.city_name;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {

    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor = highlighted ? AppFontf3f3f3Color : [UIColor whiteColor];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    selected = !selected;
     self.contentView.backgroundColor = !selected ? AppFontf3f3f3Color : [UIColor whiteColor];
    // Configure the view for the selected state
}

@end

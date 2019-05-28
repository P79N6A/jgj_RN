//
//  JGJSearchCityCell.m
//  mix
//
//  Created by celion on 16/4/15.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJSearchCityCell.h"

@interface JGJSearchCityCell ()
@property (weak, nonatomic) IBOutlet UILabel *searchCity;
@end

@implementation JGJSearchCityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.searchCity.font = [UIFont systemFontOfSize:AppFont30Size];
    self.searchCity.textColor = AppFont333333Color;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"Cell";
    JGJSearchCityCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJSearchCityCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setCityModel:(JLGCityModel *)cityModel {
    
    _cityModel = cityModel;
    self.searchCity.text = cityModel.city_name;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
    [super setHighlighted:highlighted animated:animated];
    self.contentView.backgroundColor = highlighted ? AppFontfafafaColor : [UIColor whiteColor];
    
}

@end

//
//  JLGCitysListTableViewCell.m
//  mix
//
//  Created by Tony on 16/1/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGCitysListTableViewCell.h"

@interface JLGCitysListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *proNumLabel;

@end
@implementation JLGCitysListTableViewCell

- (void)setCitysModel:(JLGCitysListModel *)citysModel{
    _citysModel = citysModel;
    NSString *proNumString = [NSString stringWithFormat:@"%@个工作",@(citysModel.pronum)];
    self.cityNameLabel.text = citysModel.city_name;
    self.proNumLabel.text = proNumString;
}
@end

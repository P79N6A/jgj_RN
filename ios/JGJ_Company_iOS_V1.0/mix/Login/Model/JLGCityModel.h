//
//  JLGCityModel.h
//  mix
//
//  Created by jizhi on 15/12/5.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@interface JLGCityModel : TYModel
@property (nonatomic,copy) NSString  *parent_id; //父级城市ID
@property (nonatomic,copy) NSString  *city_name; //城市名
@property (nonatomic,copy) NSString  *city_code; //城市ID
@property (nonatomic,copy) NSString  *first_char;
@property (nonatomic,copy) NSString  *short_name;
@property (nonatomic,copy) NSString  *city_url;
@property (nonatomic,copy) NSString  *is_all_area;//查看全国数据是为1，其余城市则传城市编码
@property (nonatomic, copy) NSString *provinceCityName;//省和当前城市
@end

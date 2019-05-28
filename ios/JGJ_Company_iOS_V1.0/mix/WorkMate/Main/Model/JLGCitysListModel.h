//
//  JLGCitysListModel.h
//  mix
//
//  Created by Tony on 16/1/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "TYModel.h"

@class CityListWorktype,CityListCity;

@interface JLGCitysListModel : TYModel

@property (nonatomic, assign) NSInteger city_code;

@property (nonatomic, assign) NSInteger pronum;

@property (nonatomic, copy) NSArray *shortname;

@property (nonatomic, copy) NSString *city_name;
@end


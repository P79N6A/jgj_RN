//
//  TLCityPickerController.h
//  TLCityPickerDemo
//
//  Created by 李伯坤 on 15/11/5.
//  Copyright © 2015年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYFMDB.h"
#import "TLCity.h"
#import "TLCityPickerDelegate.h"


//常用地址最多存放数
#define     MAX_COMMON_CITY_NUMBER      4
#define     COMMON_CITY_DATA_KEY        @"TLCityPickerCommonCityArray"

@interface TLCityPickerController : UITableViewController

@property (nonatomic, assign) id<TLCityPickerDelegate>delegate;

/*
 *  定位城市id
 */
@property (nonatomic, strong) NSString *locationCityID;

/*
 *  常用城市id数组,自动管理，也可赋值
 */
@property (nonatomic, strong) NSMutableArray *commonCitys;

/*
 *  热门城市id数组
 */
@property (nonatomic, strong) NSArray *hotCitys;


/*
 *  城市数据，可在Getter方法中重新指定
 */
@property (nonatomic, strong) NSMutableArray *data;//需要的数据

@property (nonatomic, strong) UIButton *leftButton;

@end

//
//  JGJLocationManger.h
//  mix
//
//  Created by yj on 2018/3/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@class BMKPoiInfo;

@interface JGJLocationMangerModel : NSObject

@property (nonatomic, strong) BMKPoiInfo *poiInfo;

// 省
@property (nonatomic, strong) NSString *province;

// 市
@property (nonatomic, strong) NSString *city;
///POI名称
@property (nonatomic, strong) NSString* name;

///POI地址
@property (nonatomic, strong) NSString* address;

///POI坐标
@property (nonatomic) CLLocationCoordinate2D pt;

@end

typedef void(^JGJLocationMangerBlock)(JGJLocationMangerModel *locationMangerModel);

@interface JGJLocationManger : NSObject

+ (id)locationMangerBlock:(JGJLocationMangerBlock)locationMangerBlock;

//发送位置给服务器

+ (void)requstLocation;

@end

//
//  JGJLocationManger.m
//  mix
//
//  Created by yj on 2018/3/14.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJLocationManger.h"

#import "JLGAppDelegate.h"

@implementation JGJLocationMangerModel



@end

@interface JGJLocationManger ()

<

    BMKLocationServiceDelegate,

    BMKGeoCodeSearchDelegate

>

{
    
    BMKLocationService* _locService;
    
    BMKReverseGeoCodeOption *_reverseGeoCodeSearchOption;
    
    BMKGeoCodeSearch *_getCodeSearch;
    
}

@property (copy, nonatomic) JGJLocationMangerBlock locationMangerBlock;

@property (strong, nonatomic) JGJLocationMangerModel *localInfoModel;

@end

@implementation JGJLocationManger

static JGJLocationManger *_locationManger;

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self startLocation];
        
        [self initialReverseGeo];
    }
    
    return self;
}

#pragma mark - 授权状态
+ (BOOL)authorStatusDenied {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];

    if (status == kCLAuthorizationStatusDenied) {

        JLGAppDelegate *appDelegate = (JLGAppDelegate *)[UIApplication sharedApplication].delegate;

        [appDelegate unOpenLocalTilte:@"打开定位" message:@"“项目中的签到”功能需要你的同意，才能在使用期间访问位置信息"];
    }
    
    return status == kCLAuthorizationStatusDenied;
}

+ (id)locationMangerBlock:(JGJLocationMangerBlock)locationMangerBlock {
    
    [self authorStatusDenied];
    
    _locationManger = [[JGJLocationManger alloc] init];
    
    _locationManger.locationMangerBlock = locationMangerBlock;
    
    return _locationManger;
}

//地图启动定位
- (void)startLocation{
    
    _locService = [[BMKLocationService alloc]init];
    
    _locService.delegate = self;
    
    [_locService startUserLocationService];
    
}

- (void)initialReverseGeo {
    
    _reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    
    _getCodeSearch = [[BMKGeoCodeSearch alloc]init];
    
    _getCodeSearch.delegate = self;
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
//    [_locService stopUserLocationService];
    
// 发起反向地理编码检索
    
    _reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;

    BOOL flag = [_getCodeSearch reverseGeoCode:_reverseGeoCodeSearchOption];
    
    NSString *geoString = flag == YES?@"成功":@"失败";
    
    TYLog(@"反Geo检索发送%@",geoString);

}

#pragma mark 接收反向地理编码结果
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        
        [TYUserDefaults setObject:[NSString stringWithFormat:@"%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district] forKey:JLGCityWebName];
        
        NSString *locationAddress = [NSString stringWithFormat:@"%@%@%@",result.addressDetail.city,result.addressDetail.district,result.addressDetail.streetName];
        [TYUserDefaults setObject:locationAddress forKey:JGJLocationAddress];
        
        BMKPoiInfo *poiInfo = (BMKPoiInfo *)[result.poiList firstObject];
        [TYUserDefaults setObject:poiInfo.name forKey:JGJLocationAddressDetail];
        
        CLLocationDegrees latitude  = result.location.latitude;
        
        CLLocationDegrees longitude = result.location.longitude;
        TYLog(@"百度地图更新经纬度:\nlat %f,\nlong %f",latitude,longitude);
        
        self.localInfoModel.province = result.addressDetail.province;
        
        self.localInfoModel.city = result.addressDetail.city;
        
        self.localInfoModel.name = poiInfo.name;
        
        self.localInfoModel.address = poiInfo.address;
        
        self.localInfoModel.pt = poiInfo.pt;

        
        TYLog(@"%@ --- %@----- %@", poiInfo.name, locationAddress, [NSString stringWithFormat:@"%@%@%@",result.addressDetail.province,result.addressDetail.city,result.addressDetail.district]);
        
        self.localInfoModel.poiInfo = poiInfo;
        
        if (self.locationMangerBlock) {
            
            self.locationMangerBlock(self.localInfoModel);
        }
    }
    
    [_locService stopUserLocationService];
}

- (JGJLocationMangerModel *)localInfoModel {
    
    if (!_localInfoModel) {
        
        _localInfoModel = [[JGJLocationMangerModel alloc] init];
        
    }
    
    return _localInfoModel;
}

#pragma mark -发送位置给服务器

+ (void)requstLocation {
    
    NSString *adcode = [TYUserDefaults objectForKey:JLGCityNo];
    
    NSString *lat = [TYUserDefaults objectForKey:JLGLatitude];
    
    NSString *lng = [TYUserDefaults objectForKey:JLGLongitude];
    
    NSString *location = [NSString stringWithFormat:@"%@,%@", lng,lat];
    
    if ([NSString isEmpty:lat] || [NSString isEmpty:lng] || [NSString isEmpty:adcode]) {
        
        return;
    }
    
    NSDictionary *parameters = @{
                                 @"location" : location?:@"",
                                 
                                 @"region" : adcode
                                 
                                 };
    
    [JLGHttpRequest_AFN PostWithNapi:@"sys/common" parameters:parameters success:^(id responseObject) {
        
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

@end

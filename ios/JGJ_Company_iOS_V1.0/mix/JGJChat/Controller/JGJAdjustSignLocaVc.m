//
//  JGJAdjustSignLocaVc.m
//  JGJCompany
//
//  Created by yj on 2017/7/21.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAdjustSignLocaVc.h"

#import "JGJAdjustSignLocaCell.h"

/**
 *  百度api
 */
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#import "JGJAddSignModel.h"

#import "NSString+Extend.h"

#import "MJRefresh.h"

#define screen_width [UIScreen mainScreen].bounds.size.width
#define screen_height [UIScreen mainScreen].bounds.size.height
#define Myuser [NSUserDefaults standardUserDefaults]

#define Accuracy 0.004

@interface JGJAdjustSignLocaVc ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,BMKPoiSearchDelegate, UITableViewDataSource,UITableViewDelegate>
{
    
    BMKPinAnnotationView *newAnnotation;
    
    BMKGeoCodeSearch *_geoCodeSearch;
    
    BMKReverseGeoCodeOption *_reverseGeoCodeOption;
    
    BMKLocationService *_locService;
    
    BMKPointAnnotation *_pointAnnotation;
    
    BMKPoiSearch *_poisearch;
    
}

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *mapPin;

@property (weak, nonatomic) IBOutlet UITableView *cityTableview;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewH;

@property(nonatomic,strong)NSMutableArray *cityDataArr;

@property (nonatomic, strong) NSIndexPath *lastIndexPath;

//选中的签到模型
@property (nonatomic, strong) JGJAddSignModel *selSignModel;

@property (nonatomic, strong) BMKNearbySearchOption *nearbySearchOption;
@end

@implementation JGJAdjustSignLocaVc

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initLocationService];
    
    _pointAnnotation = [[BMKPointAnnotation alloc]init];
    
    self.mapViewH.constant = TYGetUIScreenWidth * 0.7;
    
    [self initialMapLocation];
    
    self.cityTableview.backgroundColor = AppFontf1f1f1Color;
    
    [TYShowMessage showHUDWithMessage:@"数据获取中"];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

}

-(void)viewWillDisappear:(BOOL)animated {

    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
    if (_mapView) {
        _mapView = nil;
    }
}


- (void)initialMapLocation {

    if (self.addSignModel.pt.latitude > 0) {
        
        _pointAnnotation.coordinate = self.addSignModel.pt;
        
        _mapView.centerCoordinate = self.addSignModel.pt;
        
        self.selSignModel = self.addSignModel;
        
        [_mapView addAnnotation:_pointAnnotation];
        
        //初始化附近搜索
        [self getNearbySearchLocation];
        
    }

}

- (void)getNearbySearchLocation {

    if (!self.nearbySearchOption) {
        
        BMKNearbySearchOption *nearbySearchOption = [[BMKNearbySearchOption alloc] init];
        
        self.nearbySearchOption = nearbySearchOption;
        
        nearbySearchOption.radius = 500;
        
        nearbySearchOption.location = self.addSignModel.pt;
        
        nearbySearchOption.pageIndex = 0;
        
        nearbySearchOption.pageCapacity = 30;
        
        nearbySearchOption.keyword = [NSString stringWithFormat:@"%@%@", self.addSignModel.sign_addr,self.addSignModel.sign_addr2];
        
        nearbySearchOption.sortType = BMK_POI_SORT_BY_DISTANCE;
    }
    
    _poisearch = [[BMKPoiSearch alloc]init];
    
    _poisearch.delegate = self;
    
    [self poiSearchNearWithPoiSearchOption];
}

- (void)poiSearchNearWithPoiSearchOption {
    
    BOOL flag = [_poisearch poiSearchNearBy:self.nearbySearchOption];
    
    if(flag)
    {
        NSLog(@"范围内检索发送成功");
    }
    else
    {
        NSLog(@"范围内检索发送失败");
        
        [self.cityTableview.mj_footer endRefreshing];
    }
}

#pragma mark  tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cityDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    JGJAddSignModel *addSignModel = self.cityDataArr[indexPath.row];

    JGJAdjustSignLocaCell *adjustSignLocaCell = [JGJAdjustSignLocaCell cellWithTableView:tableView];
    
    adjustSignLocaCell.addSignModel = addSignModel;
    
    return adjustSignLocaCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJAddSignModel *addSignModel = self.cityDataArr[indexPath.row];
    
    self.selSignModel = addSignModel;
    
    addSignModel.isSelected = !addSignModel.isSelected;
    
    BMKPoiInfo *poiInfo = self.cityDataArr[indexPath.row];
    
    CLLocationCoordinate2D coord = poiInfo.pt;
    
    _pointAnnotation.coordinate = coord;
    
    _mapView.centerCoordinate = coord;
    
    [_mapView addAnnotation:_pointAnnotation];
    
    NSIndexPath *temp = self.lastIndexPath;
    
    if(temp && temp != indexPath) {
        
        JGJAddSignModel *lastAddSignModel = self.cityDataArr[self.lastIndexPath.row];
        
        lastAddSignModel.isSelected = NO;//修改之前选中的cell的数据为不选中
        
        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationNone];
    }
    //选中的修改为当前行
    
    self.lastIndexPath = indexPath;
    
    addSignModel.isSelected = YES;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJAddSignModel *addSignModel = self.cityDataArr[indexPath.row];
    
    return addSignModel.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
}

#pragma mark 初始化地图，定位
-(void)initLocationService
{
    
    [_mapView setMapType:BMKMapTypeStandard];// 地图类型 ->卫星／标准、
    
    _mapView.zoomLevel = 19;
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;

//    if (_locService == nil) {
//        
//        _locService = [[BMKLocationService alloc]init];
//        
//        [_locService setDesiredAccuracy:kCLLocationAccuracyBest];
//    }
//    
//    _locService.delegate = self;
//    
//    [_locService startUserLocationService];
    
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = YES;//跟随态旋转角度是否生效
    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示
    displayParam.locationViewImgName= @"no_icon";//定位图标名称
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [_mapView updateLocationViewWithParam:displayParam];
    
}

//#pragma mark BMKLocationServiceDelegate
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
//{
//    _mapView.showsUserLocation = YES;//显示定位图层
//    //设置地图中心为用户经纬度
////    [_mapView updateLocationData:userLocation];
//    
//}

#pragma mark BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    [self.cityTableview.mj_footer endRefreshing];
    
    //获取周边用户信息
    if (error==BMK_SEARCH_NO_ERROR) {
        
        if (result.poiList.count > 0) {
            
            self.nearbySearchOption.pageIndex++;
        }
        
        if (self.cityDataArr.count == 0) {
            
            self.addSignModel.isSelected = YES;
            
            self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.cityDataArr addObject:self.addSignModel];
            
            for (BMKPoiInfo *poiInfo in result.poiList) {
                
                JGJAddSignModel *addSignModel = [JGJAddSignModel new];
                
                addSignModel.sign_addr2 = poiInfo.name;
                
                addSignModel.sign_addr = poiInfo.address;
                
                addSignModel.pt = poiInfo.pt;
                
                addSignModel.province = result.addressDetail.province;
                
                addSignModel.city = result.addressDetail.city;
                [self.cityDataArr addObject:addSignModel];
                
            }
            
            if (self.cityDataArr.count > 0) {
                
                JGJAddSignModel *addSignModel = self.cityDataArr.lastObject;
                
                self.nearbySearchOption.keyword = [NSString stringWithFormat:@"%@%@", addSignModel.sign_addr,addSignModel.sign_addr2];
            }
        }
        
    }else{
        
        NSLog(@"BMKSearchErrorCode: %u",error);
        
        if (result.poiList.count == 0) {
            
            [self.cityDataArr removeAllObjects];
            
            self.addSignModel.isSelected = YES;
            
            self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.cityDataArr addObject:self.addSignModel];
        }
    }
    
    [TYShowMessage hideHUD];
    
    [self.cityTableview reloadData];
    
}

#pragma mark implement BMKSearchDelegate
- (void)onGetPoiResult:(BMKPoiSearch *)searcher result:(BMKPoiResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR) {
//        NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//        [_mapView removeAnnotations:array];
//        array = [NSArray arrayWithArray:_mapView.overlays];
//        [_mapView removeOverlays:array];
        
        //在此处理正常结果
        for (int i = 0; i < result.poiInfoList.count; i++)
        {
            BMKPoiInfo* poi = [result.poiInfoList objectAtIndex:i];
            
            if (_geoCodeSearch==nil) {
                //初始化地理编码类
                _geoCodeSearch = [[BMKGeoCodeSearch alloc]init];
                
                _geoCodeSearch.delegate = self;
                
            }
            if (_reverseGeoCodeOption==nil) {
                
                //初始化反地理编码类
                _reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
            }
            
            _reverseGeoCodeOption.reverseGeoPoint = poi.pt;
            
            [_geoCodeSearch reverseGeoCode:_reverseGeoCodeOption];
        }
        
    } else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
        NSLog(@"起始点有歧义");
    } else {
        // 各种情况的判断。。。
    }
}

#pragma mar - 确定按钮按下
- (IBAction)handleRightItemPressed:(UIBarButtonItem *)sender {
    
    if (self.handleSelSignModelBlock) {
        
        self.handleSelSignModelBlock(self.selSignModel);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSMutableArray *)cityDataArr
{
    if (_cityDataArr == nil)
    {
        _cityDataArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _cityDataArr;
}

@end

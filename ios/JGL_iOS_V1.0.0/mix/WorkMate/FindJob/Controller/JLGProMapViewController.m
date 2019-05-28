//
//  JLGProMapViewController.m
//  mix
//
//  Created by jizhi on 15/12/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGProMapViewController.h"
#import "JLGBaseBMapView.h"
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

@interface JLGProMapViewController ()
@property (weak, nonatomic) IBOutlet JLGBaseBMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *proNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *proAddressLabel;

@end

@implementation JLGProMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.proNameLabel.text = self.proname;
    self.proAddressLabel.text = self.proaddress;
    self.mapView.titleString = self.proname;
    self.mapView.subtitleString = self.proaddress;

    self.mapView.prolocation = self.prolocation;
}

#pragma mark - 开启导航
//打开客户端导航
- (IBAction)openNativeNavi {
    //初始化调启导航时的参数管理类
    BMKNaviPara* para = [[BMKNaviPara alloc]init];
    //初始化起点节点
    BMKPlanNode* start = [[BMKPlanNode alloc]init];

    //指定起点经纬度
    CLLocationCoordinate2D coor1;
    coor1.latitude = [[TYUserDefaults objectForKey:JLGLatitude] floatValue];
    coor1.longitude = [[TYUserDefaults objectForKey:JLGLongitude] floatValue];
    
    start.pt = coor1;
    //指定起点名称
    start.name = @"我的位置";
    //指定起点
    para.startPoint = start;
    
    //初始化终点节点
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    //指定终点经纬度
    CLLocationCoordinate2D coor2;
    coor2.latitude = [self.prolocation[1] floatValue];
    coor2.longitude = [self.prolocation[0] floatValue];
    end.pt = coor2;
    //指定终点名称
    end.name = self.proname;
    //指定终点
    para.endPoint = end;
    
    //指定返回自定义scheme
    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
    
    //调启百度地图客户端导航
    [BMKNavigation openBaiduMapNavigation:para];
}
@end

//
//  JLGBaseBMapView.m
//  mix
//
//  Created by jizhi on 15/12/16.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGBaseBMapView.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface JLGBaseBMapView ()
<
    BMKMapViewDelegate
>
{
    BMKPointAnnotation* _projectAnnotation;
}

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@end

@implementation JLGBaseBMapView
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
}

-(void)setupBMap{
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;//先关闭显示的定位图层
    self.mapView.zoomEnabledWithTap = NO;//不支持点击
    self.mapView.rotateEnabled = NO;//不支持旋转
    self.mapView.overlookEnabled = NO;//不支持俯仰角
    self.mapView.zoomLevel = 16.0;
    self.mapView.scrollEnabled = NO;//地图不可移动
    self.mapView.showsUserLocation = YES;
    self.titleString = @"";
    self.subtitleString = @"";
    

}

- (void)dealloc{
    self.mapView.delegate = nil;
}

//绘画
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self setupBMap];
}

- (void)setProlocation:(NSArray *)prolocation{
    _prolocation = prolocation;
    CLLocationCoordinate2D projectCoordinate;
    projectCoordinate.latitude = [prolocation[1] floatValue];
    projectCoordinate.longitude = [prolocation[0] floatValue];
    
    [self addProjectAnnotation:projectCoordinate];
}

- (void)setZoomLevel:(CGFloat)zoomLevel{
    _zoomLevel = zoomLevel;
    self.mapView.zoomLevel = self.zoomLevel;
}

- (void)addProjectAnnotation: (CLLocationCoordinate2D )projectCoordinate{
    _projectAnnotation = [[BMKPointAnnotation alloc]init];
    _projectAnnotation.coordinate = projectCoordinate;
    _projectAnnotation.title = self.titleString;
    _projectAnnotation.subtitle = self.subtitleString;
    
    [self.mapView removeAnnotations:_mapView.annotations];
    [self.mapView addAnnotation:_projectAnnotation];
    
    BMKCoordinateRegion region ;//表示范围的结构体
    region.center = projectCoordinate;//中心点
    [self.mapView setRegion:region animated:YES];
}

// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    NSString *AnnotationViewID = @"renameMark";
    BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        // 设置颜色
        annotationView.pinColor = BMKPinAnnotationColorRed;
        // 从天上掉下效果
        annotationView.animatesDrop = YES;
        // 设置可拖拽
        annotationView.draggable = YES;
    }
    return annotationView;
}
- (void)mapView:(BMKMapView *)mapView1 didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude  = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta  = 0.2;
    region.span.longitudeDelta = 0.2;
    if (_mapView)
    {
        _mapView.region = region;
        TYLog(@"当前的坐标是: %f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    }
}

@end

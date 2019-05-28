//
//  JGJMapViewController.m
//  mix
//
//  Created by Json on 2019/5/8.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJMapViewController.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "JGJPosition.h"

@interface JGJMapViewController ()<BMKMapViewDelegate>
@property (nonatomic, weak) BMKMapView *mapView;
@end

@implementation JGJMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"查看地图";
    
    BMKMapView *mapView = [[BMKMapView alloc] init];
    mapView.delegate = self;
    mapView.zoomLevel = 19;
    mapView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:mapView];
    self.mapView = mapView;
    [mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    // 添加
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CGFloat latitude = self.postion.latitude;
    CGFloat longitude = self.postion.longitude;
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [self.mapView addAnnotation:annotation];
    
    // 
    [self.mapView setCenterCoordinate:annotation.coordinate];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mapView viewWillAppear];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
}

#pragma mark - BMKMapViewDelegate

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        static NSString *reusedId = @"pointAnnotation";
        BMKPinAnnotationView *annoView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reusedId];
        if (!annoView) {
            annoView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reusedId];
        }
        return annoView;
    }
    return nil;
}



@end

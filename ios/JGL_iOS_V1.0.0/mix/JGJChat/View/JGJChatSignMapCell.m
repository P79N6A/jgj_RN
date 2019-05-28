//
//  JGJChatSignMapCell.m
//  mix
//
//  Created by yj on 17/3/4.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJChatSignMapCell.h"
#import "JLGBaseBMapView.h"
#import "CustomView.h"

@interface JGJChatSignMapCell ()

@property (weak, nonatomic) IBOutlet LineView *lineView;

@end

@implementation JGJChatSignMapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = AppFontf1f1f1Color;
    self.mapView.zoomLevel = 19;
    self.mapView.backgroundColor = [UIColor whiteColor];
    self.mapView.userTrackingMode = BMKUserTrackingModeNone;
    
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc]init];
    displayParam.isRotateAngleValid = NO;
    displayParam.isAccuracyCircleShow = NO;
    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
    [self.mapView updateLocationViewWithParam:displayParam];
    
    self.mapView.showsUserLocation = YES;//显示定位图层
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

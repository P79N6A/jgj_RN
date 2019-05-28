//
//  JGJChatSignMapCell.h
//  mix
//
//  Created by yj on 17/3/4.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJAddSignModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

@interface JGJChatSignMapCell : UITableViewCell

@property (nonatomic,strong) JGJAddSignModel *addSignModel;

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@end

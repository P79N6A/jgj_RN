//
//  JLGBMapTableViewCell.m
//  mix
//
//  Created by jizhi on 15/11/29.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGBMapTableViewCell.h"
#import "JLGBaseBMapView.h"

@interface JLGBMapTableViewCell()
@property (weak, nonatomic) IBOutlet JLGBaseBMapView *mapView;
@end

@implementation JLGBMapTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setProlocation:(NSArray *)prolocation{
    if (!prolocation || prolocation.count < 1) {
        return ;
    }
    _prolocation = prolocation;
    self.mapView.prolocation = prolocation;
}
@end

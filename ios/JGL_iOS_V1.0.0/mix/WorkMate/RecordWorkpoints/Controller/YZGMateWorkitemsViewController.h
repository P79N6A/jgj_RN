//
//  YZGMateWorkitemsViewController.h
//  mix
//
//  Created by Tony on 16/2/24.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YZGMateWorkitemsViewController : UIViewController

@property (nonatomic, strong) NSDate *searchDate;//查询日期

- (void)JLGHttpRequest;
@end

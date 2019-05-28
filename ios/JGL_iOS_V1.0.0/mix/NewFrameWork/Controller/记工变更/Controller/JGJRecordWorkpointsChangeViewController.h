//
//  JGJRecordWorkpointsChangeViewController.h
//  mix
//
//  Created by Tony on 2018/8/2.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJRecordWorkpointsChangeViewController : UIViewController

//代理班组长
@property (nonatomic, strong) JGJMyWorkCircleProListModel *proListModel;
@property (nonatomic, strong) NSMutableArray *changeListArr;
@property (nonatomic, strong) NSString *group_id;


@end

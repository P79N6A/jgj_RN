//
//  JGJUpgradeGroupSelectedMangerVc.h
//  mix
//
//  Created by yj on 16/12/27.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JGJUpgradeGroupSelectedMangerVc : UIViewController
/**
 *  升级为班组选择的创建者成员
 */
@property (nonatomic, strong) NSMutableArray *members;
/**
 *  群聊信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (strong, nonatomic) NSIndexPath *lastIndexPath;

@end

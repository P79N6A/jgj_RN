//
//  JGJTeamMangerVC.h
//  mix
//
//  Created by YJ on 16/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJTeamMangerVC : UIViewController
/**
 *  页面类型区分
 */
@property (nonatomic, assign) JGJTeamMangerVcType teamMangerVcType;


/**
 *  班组信息
 */
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@end

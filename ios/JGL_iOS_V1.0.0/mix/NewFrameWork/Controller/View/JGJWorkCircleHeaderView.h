//
//  JGJWorkCircleHeaderView.h
//  mix
//
//  Created by yj on 16/8/17.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WorkCircleHeaderViewBlock)(WorkCircleHeaderFooterViewButtonType);
@interface JGJWorkCircleHeaderView : UIView
@property (nonatomic, copy) WorkCircleHeaderViewBlock workCircleHeaderViewBlock;

@property (nonatomic, assign) WorkCircleProType workCircleProType;

@property (strong, nonatomic) JGJMyWorkCircleProListModel *proListModel;//当前选中的项目
@end

//
//  JGJCusProgress.h
//  mix
//
//  Created by yj on 17/4/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JGJCusProgress : UIView

//自制进度条上面有两个视图，左视图显示下载量，有视图显示未下载的内容。还有一个label显示下载的进度值。再次也设定一个最大值
@property(nonatomic, strong)UIImageView *leftView;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, assign) CGFloat progressHeight;

@end

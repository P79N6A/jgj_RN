//
//  JGJKnowledgeDaseTool.h
//  mix
//
//  Created by yj on 2017/9/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JGJKnowledgeDaseTool : UIViewController

- (void )showShareBtnClick:(NSString *)img desc:(NSString *)desc title:(NSString *)title url:(NSString *)url;

//弹出分享的页面
@property (nonatomic,strong) UIViewController *targetVc;

//是否清除分享次数，当前资料库需要计算次数 isUnCanShareCount YES 不清楚，反之清除(资料库默认是NO,项目设置YES)
@property (nonatomic,assign) BOOL isUnCanShareCount;
@end

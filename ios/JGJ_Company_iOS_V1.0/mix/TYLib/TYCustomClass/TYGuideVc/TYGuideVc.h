//
//  TYGuideVc.h
//  HuDuoDuoLogistics
//
//  Created by jizhi on 15/5/11.
//  Copyright (c) 2015年 JiZhiShengHuo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^finishBlock)();

@interface TYGuideVc : UIViewController
- (instancetype)initWithBlock:(finishBlock )block;
@end

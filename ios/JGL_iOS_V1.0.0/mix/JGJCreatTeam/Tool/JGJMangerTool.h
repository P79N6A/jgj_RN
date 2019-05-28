//
//  JGJMangerTool.h
//  mix
//
//  Created by yj on 2018/7/9.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JGJMangerToolBlock)();

@interface JGJMangerTool : NSObject

@property (nonatomic, copy) JGJMangerToolBlock toolTimerBlock;

//时间间隔默认是2s执行
@property (nonatomic, assign) NSTimeInterval timeInterval;

//定时器失效次数
@property (nonatomic, assign) NSInteger inValidCount;

+(instancetype)mangerTool;

- (NSTimer *)startTimer;

- (void)inValidTimer;

@end

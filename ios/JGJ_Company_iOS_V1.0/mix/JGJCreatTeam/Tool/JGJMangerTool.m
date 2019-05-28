//
//  JGJMangerTool.m
//  mix
//
//  Created by yj on 2018/7/9.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMangerTool.h"

static JGJMangerTool *_tool;

@interface JGJMangerTool()

//刷新页面timer
@property (nonatomic, strong) NSTimer *startTimer;

@end

@implementation JGJMangerTool

+(instancetype)mangerTool {
    
    _tool = [[JGJMangerTool alloc] init];
    
    _tool.inValidCount = 0;
    
    return _tool;
    
}

- (NSTimer *)startTimer {
    
    if (!_startTimer) {
        
        // 调用了scheduledTimer返回的定时器，已经自动被添加到当前runLoop中，而且是NSDefaultRunLoopMode
        NSTimeInterval timeInterval = [NSString isFloatZero:self.timeInterval] ? 2.0 : self.timeInterval;
        
        _startTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(freshMsg:) userInfo:nil repeats:YES];
        
        // 修改模式
        [[NSRunLoop currentRunLoop] addTimer:_startTimer forMode:NSRunLoopCommonModes];
        
    }
    
    return _startTimer;
}

- (void)freshMsg:(NSTimer *)timer {
    
    if (self.toolTimerBlock) {
        
        TYLog(@"----freshMsg-----");
        
        self.toolTimerBlock();
        
    }
    
}

- (void)inValidTimer {
    
    if (_startTimer) {
        
        [_startTimer invalidate];
        
        _startTimer = nil;
        
        self.inValidCount++;
    }
}
@end


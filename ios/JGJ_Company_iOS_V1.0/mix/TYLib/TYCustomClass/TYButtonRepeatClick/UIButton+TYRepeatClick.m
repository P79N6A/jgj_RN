//
//  UIButton+TYRepeatClick.m
//  mix
//
//  Created by Tony on 2016/11/14.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "UIButton+TYRepeatClick.h"

/*
 * 默认重复点击的时间
 */
static const CGFloat KTYRepeatClickTime = 0.01f;

@interface UIButton ()

/*
 * 是否不需要点击,YES，不需要，NO,需要
 */
@property (nonatomic, assign) BOOL canNotClick;

@end

@implementation UIButton (TYRepeatClick)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldSEL = @selector(sendAction:to:forEvent:);
        SEL newSEL = @selector(repeatClickSendAction:to:forEvent:);
        
        Method oldMethod =   class_getInstanceMethod(self,oldSEL);
        Method newMethod = class_getInstanceMethod(self, newSEL);

        //添加新方法，如果不存在就会添加，如果存在就不添加
        BOOL isAdd = class_addMethod(self, oldSEL, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        
        
        if (isAdd) {//不存在，直接替换
            class_replaceMethod(self, newSEL, method_getImplementation(oldMethod), method_getTypeEncoding(oldMethod));
        }else{//存在，直接交换
            method_exchangeImplementations(oldMethod, newMethod);
        }
    });
}

- (void)repeatClickSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        
        self.repeatClickTime = self.repeatClickTime == 0?KTYRepeatClickTime:self.repeatClickTime;
        
        if (self.canNotClick){
            return;
        }else if (self.repeatClickTime > 0){
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.repeatClickTime];
        }
    }

    [self setCanNotClick:YES];
    [self repeatClickSendAction:action to:target forEvent:event];
}

- (void)resetState{
    [self setCanNotClick:NO];
}


- (NSTimeInterval)repeatClickTime
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setRepeatClickTime:(NSTimeInterval)repeatClickTime
{
    objc_setAssociatedObject(self, @selector(repeatClickTime), @(repeatClickTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (void)setCanNotClick:(BOOL)canNotClick{
    objc_setAssociatedObject(self, @selector(canNotClick), @(canNotClick), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)canNotClick{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
@end

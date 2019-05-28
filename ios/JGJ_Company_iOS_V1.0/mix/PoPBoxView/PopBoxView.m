//
//  PopBoxView.m
//  HuDuoDuoCustomer
//
//  Created by Tony on 15/8/26.
//  Copyright (c) 2015年 celion. All rights reserved.
//

#import "PopBoxView.h"
#import "NSArray+Extend.h"
#import "PopBox_NormalView.h"

typedef NS_ENUM(NSUInteger, PopViewMode)
{
    PopViewTypeDefault,
    PopViewTypePeople,
};

@interface PopBoxView()
<
    PopBoxNormalViewDelegate
>
@end

@implementation PopBoxView

+ (id)showBoxNormalTo:(UIView *)view delegate:(id)customClass{
    return [self showBoxNormalTo:view delegate:customClass message:nil];
}

+ (id)showBoxPeopleTo:(UIView *)view delegate:(id)customClass{
    return [self showBoxPeopleTo:view delegate:customClass message:nil];
}

+ (id)showBoxNormalTo:(UIView *)view delegate:(id)customClass message:(NSString *)message cancelButtonTitle:(NSString *)cancelString destructiveButtonTitle:(NSString *)destructiveString{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    if ([view.subviews containsClass:self]) {
        return nil;
    }
    
    PopBoxView *popBox = [[self alloc] initWithView:view WithMode:PopViewTypeDefault message:message cancelButtonTitle:(NSString *)cancelString destructiveButtonTitle:(NSString *)destructiveString];
    popBox.delegate = customClass;
    [view addSubview:popBox];
    
    return popBox;
}

+ (id)showBoxNormalTo:(UIView *)view delegate:(id)customClass message:(NSString *)message{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    PopBoxView *popBox = [[self alloc] initWithView:view WithMode:PopViewTypeDefault message:message];
    popBox.delegate = customClass;
    [view addSubview:popBox];
    
    return popBox;
}

+ (id)showBoxPeopleTo:(UIView *)view delegate:(id)customClass message:(id )message{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    PopBoxView *popBox = [[self alloc] initWithView:view WithMode:PopViewTypePeople message:message];
    popBox.delegate = customClass;
    [view addSubview:popBox];
    
    return popBox;
}

- (id)initWithView:(UIView *)view WithMode:(PopViewMode) mode message:(id )message{
    return [self initWithFrame:view.bounds mode:mode message:message cancelButtonTitle:nil destructiveButtonTitle:nil];
}

- (id)initWithView:(UIView *)view WithMode:(PopViewMode) mode message:(id )message cancelButtonTitle:(NSString *)cancelString destructiveButtonTitle:(NSString *)destructiveString{
    
    return [self initWithFrame:view.bounds mode:mode message:message cancelButtonTitle:cancelString destructiveButtonTitle:(NSString *)destructiveString];
}

- (id)initWithFrame:(CGRect)frame mode:(PopViewMode)mode message:(id )message cancelButtonTitle:(NSString *)cancelString destructiveButtonTitle:(NSString *)destructiveString{
    self = [super initWithFrame:frame];
    self.backgroundColor = TYColorHexAlpha(0x000000, 0.4);
    if (self) {
        CGFloat viewCenterX = frame.size.width/2;
        CGFloat viewCenterY = frame.size.height/2;
        UIView *popBoxView;
        if (mode == PopViewTypeDefault) {
            PopBox_NormalView *popBoxViewTmp = [[PopBox_NormalView alloc] initWithFrame:CGRectMake(0,0,260,190)];
            popBoxViewTmp.center = CGPointMake(viewCenterX, viewCenterY - 20);
            popBoxViewTmp.delegate = self;
            
            if (message) {
                [popBoxViewTmp setPopBoxNormalMessage:message cancelButtonTitle:cancelString destructiveButtonTitle:destructiveString];
            }
            
            popBoxView = popBoxViewTmp;
        }
        [self addSubview:popBoxView];
    }
    return self;
}

+ (BOOL)hidePopForView:(UIView *)view{
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    
    PopBoxView *popBox = [self PopForView:view];
    
    if (popBox != nil) {
        popBox.alpha = 0.0f;
        [popBox.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[PopBox_NormalView class]]) {
                PopBox_NormalView *popBoxNormal = (PopBox_NormalView *)obj;
                popBoxNormal.delegate = nil;
                [popBoxNormal removeFromSuperview];
            }
        }];
        popBox.delegate = nil;
        [popBox removeFromSuperview];
        return YES;
    }
    return NO;
}


+ (id)PopForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:self]) {
            return (PopBoxView *)subview;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [PopBoxView hidePopForView:nil];
}

#pragma delegate
//normalView的隐藏
-(void)PopBoxNormalViewCancel{
    if ([self.delegate respondsToSelector:@selector(PopBoxViewCancel)]) {
        [self.delegate PopBoxViewCancel];
    }
}

//peopleView的隐藏
-(void)PopBoxPeopleViewCancel{
    if ([self.delegate respondsToSelector:@selector(PopBoxViewCancel)]) {
        [self.delegate PopBoxViewCancel];
    }
}

//normalView的确定
-(void)PopBoxNormalViewConfirm{
    if ([self.delegate respondsToSelector:@selector(PopBoxViewConfirm)]) {
        [self.delegate PopBoxViewConfirm];
    }
}

//peopleView的确定
-(void)PopBoxPeopleViewConfirm{
    [PopBoxView hidePopForView:nil];
    if ([self.delegate respondsToSelector:@selector(PopBoxViewConfirm)]) {
        [self.delegate PopBoxViewConfirm];
    }
}

@end

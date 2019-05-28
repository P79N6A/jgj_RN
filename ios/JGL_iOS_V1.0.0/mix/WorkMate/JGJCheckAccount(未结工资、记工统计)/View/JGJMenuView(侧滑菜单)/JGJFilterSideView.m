//
//  JGJFilterSideView.m
//  mix
//
//  Created by yj on 2018/9/25.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJFilterSideView.h"

#define JGJFilterSideViewDurTime 0.4

@interface JGJFilterSideView ()

//存储子视图的容器，便于销毁
@property (nonatomic, strong) NSMutableArray *contains;

@property (nonatomic, assign) CGFloat originalY;

@property (nonatomic, assign) CGFloat limiWidth;

@property (nonatomic, strong) UIView *containView;

@end

@implementation JGJFilterSideView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self commonset];
    }
    
    return self;
    
}

- (void)commonset {
    
    _originalY = 40;
    
    _limiWidth = TYGetUIScreenWidth - _originalY;
    
}

- (void)setContainViews:(NSMutableArray *)containViews {
    
    _containViews = containViews;
    
    if (_containViews.count > 0) {
        
        self.containView = _containViews.firstObject;
    }
    
    [self pushView];
    
    self.contains = containViews;
}

- (void)pushView {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    
    [TYKey_Window addSubview:self];
    
    [self addQueueWithSubView:self.containView];
    
}

- (void)popView:(UIView *)view animation:(BOOL)animation{
    
    [self removeQueueWithSubView:view];
}

- (void)addQueueWithSubView:(UIView *)subView {
    
//    if (![self.contains containsObject:subView]) {
//        
//        [self addSubview:subView];
//        
//        [self animateWithSubView:subView];
//    }
    
    [self addSubview:subView];
    
    [self animateWithSubView:subView];
}

- (void)animateWithSubView:(UIView *)subView {
    
    [UIView animateWithDuration:JGJFilterSideViewDurTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        subView.x = _originalY;
        
        if ([subView isKindOfClass:NSClassFromString(@"JGJSideFirstView")]) {
            
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        }
        
    } completion:^(BOOL finished) {
        
        
    }];
}

- (void)removeQueueWithSubView:(UIView *)subView {
    
    if ([self.contains containsObject:subView]) {
        
        [UIView animateWithDuration:JGJFilterSideViewDurTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            if (self.contains.count == 2 && [self.containView isEqual:subView]) {
                
                self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
                
            }
            
            subView.x = TYGetUIScreenWidth;
            
        } completion:^(BOOL finished) {
            
//            [subView removeFromSuperview];
//
//            [self.contains removeObject:subView];
//
//            if (self.contains.count == 1) {
//
//                [self.contains removeAllObjects];
//
//                [self removeFromSuperview];
//            }
            
        }];
        
    }else {
        
//        [self removeFromSuperview];
        
    }
    
}

#pragma mark - 移除所有视图
- (void)removeAllView {
    
    [UIView animateWithDuration:JGJFilterSideViewDurTime delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{

        _containView.x = TYGetUIScreenWidth;

        UIView *proView = _containViews[1];
        
        UIView *mmeberView = _containViews[2];
        
        proView.x = TYGetUIScreenWidth;
        
        mmeberView.x = TYGetUIScreenWidth;
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UIView *hitView = [self hitTest:[[touches anyObject] locationInView:self] withEvent:nil];
    
    if (hitView == self) {
        
        NSSet *allTouches = [event allTouches];    //返回与当前接收者有关的所有的触摸对象
        
        UITouch *touch = [allTouches anyObject];   //视图中的所有对象
        
        CGPoint point = [touch locationInView:[touch view]]; //返回触摸点在视图中的当前坐标
        
        int x = point.x;
        
        if (x > 0 && x < _originalY) {
            
            [self removeAllView];
  
        }
        
    }
    
}


@end

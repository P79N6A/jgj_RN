//
//  JGJCoreTextLable+Category.m
//  JGJCompany
//
//  Created by yj on 2017/11/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJCoreTextLable+Category.h"

static NSString *JGJCoreTextCopyAction_key = @"JGJCoreTextCopyAction_key";

@implementation JGJCoreTextLable (Category)

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

//可以响应的方法
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copyText:))
    {
        return YES;
    }
    
    return NO;
}

//针对于响应方法的实现

-(void)copyText:(UIMenuItem*)sender
{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    pboard.string = self.text;
    
    [self resignFirstResponder];
}

-(void)attachTapHandler
{
    self.userInteractionEnabled = YES;  //用户交互的总开关
    
    UILongPressGestureRecognizer *touch = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    
    touch.minimumPressDuration = .2;
    
    [self addGestureRecognizer:touch];
}

////绑定事件
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//
//    if (self)
//    {
//        [self attachTapHandler];
//    }
//
//    return self;
//}
//
////同上
//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//
//    [self attachTapHandler];
//}

- (void)canCopy {
    
    [self attachTapHandler];
}

-(void)handleTap:(UIGestureRecognizer*)recognizer
{
    if (UIGestureRecognizerStateBegan == recognizer.state)
    {
        [self becomeFirstResponder];
        
        UIMenuItem *copyLink = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText:)];
        
        [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyLink, nil]];
        
        CGPoint location = [recognizer locationInView:[recognizer view]];
        
        CGRect menuLocation = CGRectMake(location.x, location.y, 0, 0);
        
        [[UIMenuController sharedMenuController] setTargetRect:menuLocation inView:[recognizer view]];
        
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        
        if (self.copyActionBlock) {
            
            self.copyActionBlock();
            
        }
    }
}

- (void)setCopyActionBlock:(JGJCoreTextCopyActionBlock)copyActionBlock {
    
    objc_setAssociatedObject(self, &JGJCoreTextCopyAction_key, copyActionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JGJCoreTextCopyActionBlock)copyActionBlock {
    
    return objc_getAssociatedObject(self, &JGJCoreTextCopyAction_key);
}


@end

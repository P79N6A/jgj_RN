//
//  JGJDescriptionCollectionViewCell.m
//  mix
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJDescriptionCollectionViewCell.h"
#import "UILabel+GNUtil.h"
#import "UILabel+JGJCopyLable.h"

@interface JGJDescriptionCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *backColorView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backColorViewW;

@end

@implementation JGJDescriptionCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UILongPressGestureRecognizer *longGusstrue = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(copyTexts:)];
    
    self.DesLable.userInteractionEnabled = YES;
    
    longGusstrue.minimumPressDuration = .2;
    
    [self.DesLable addGestureRecognizer:longGusstrue];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHideCallback) name:UIMenuControllerDidHideMenuNotification object:nil];
    
}
-(void)setMjSTR:(NSString *)mjSTR
{
    _DesLable.text = mjSTR;

}
- (void)copyTexts:(UIGestureRecognizer *)gesture
{
    if (UIGestureRecognizerStateBegan == gesture.state)
    {
    
        [self becomeFirstResponder];
        
        UIMenuItem *item = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyText)];
        
        NSMutableArray *itemarr = [NSMutableArray array];
        
        [itemarr addObject:item];
        
        [[UIMenuController sharedMenuController] setMenuItems:itemarr];
        
        [[UIMenuController sharedMenuController] setTargetRect:self.DesLable.frame inView:self                                                                                                                                                             ];
        
        [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        
        [self menuDidShowCallback];
        
    }
    
}
-(void)copyText
{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.DesLable.text;
    
    
    
}
-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(copyText)) {
        return YES;
    }
    return NO;
}

-(float)RowHeight
{

    return _DesLable.frame.size.height;

}
- (void)setModel:(JGJChatMsgListModel *)model
{
    
    _DesLable.text = model.msg_text;
    _DesLable.font = [UIFont systemFontOfSize:15];
    _DesLable.textColor = AppFont333333Color;
    [self.DesLable SetLinDepart:5];//设置行间距
    [self.DesLable creatInternetHyperlinks];
    
    self.backColorViewW.constant = [self.DesLable sizeThatFits:CGSizeMake(TYGetUIScreenWidth - 20, CGFLOAT_MAX)].width + 3;

}

- (void)menuDidHideCallback{
    
    self.backColorView.hidden = YES;
    
    self.backColorView.backgroundColor = AppFontffffffColor;
    
}

- (void)menuDidShowCallback {
    
    self.backColorView.hidden = NO;
    
    self.backColorView.backgroundColor = AppFontccccccColor;
    
}

@end

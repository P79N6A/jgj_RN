//
//  JGJPerInfoBlackListView.m
//  mix
//
//  Created by yj on 16/12/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJPerInfoBlackListView.h"
#import "CustomView.h"
@interface JGJPerInfoBlackListView ()
@property (weak, nonatomic) IBOutlet LineView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottom;
@end
@implementation JGJPerInfoBlackListView

static JGJPerInfoBlackListView *blackListView;
- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = [[UIScreen mainScreen] bounds];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.contentViewBottom.constant -= 120.0;
}

+ (JGJPerInfoBlackListView *)perInfoBlackListView {
    if(blackListView && blackListView.superview) [blackListView removeFromSuperview];
    blackListView = [[[NSBundle mainBundle] loadNibNamed:@"JGJPerInfoBlackListView" owner:self options:nil] lastObject];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    blackListView.frame = window.bounds;
    [window addSubview:blackListView];
    [blackListView showContentView];
    return blackListView;
}

- (IBAction)handleJoinBlackListAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(perInfoBlackListView:perInfoBlackListViewButtonType:)]) {
        [self.delegate perInfoBlackListView:self perInfoBlackListViewButtonType:JGJPerInfoBlackListViewJoinBlackButtonType];
    }
    [self dismiss];
}

- (IBAction)handleCancelButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(perInfoBlackListView:perInfoBlackListViewButtonType:)]) {
        [self.delegate perInfoBlackListView:self perInfoBlackListViewButtonType:JGJPerInfoBlackListViewJoinCancelButtonType];
    }
    [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.alpha = 0.0;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        blackListView.transform = CGAffineTransformScale(blackListView.transform,0.9,0.9);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

- (void)showContentView{
    CGFloat duration = 0.1;
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentViewBottom.constant = 0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

@end

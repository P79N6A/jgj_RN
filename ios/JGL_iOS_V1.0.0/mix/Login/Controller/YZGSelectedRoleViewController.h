//
//  YZGSelectedRoleViewController.h
//  mix
//
//  Created by Tony on 16/3/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YZGSelectedRoleViewController;

typedef void(^SelRoleSuccessBlock)();
@protocol YZGSelectedRoleViewControllerDelegate <NSObject>
@optional
-(void)SelectedRoleDismiss:(YZGSelectedRoleViewController *)selectedRoleVc;
@end

@interface YZGSelectedRoleViewController : UIViewController
@property (nonatomic , weak) id<YZGSelectedRoleViewControllerDelegate> delegate;

//没完善资料隐藏按钮
@property (nonatomic, assign) BOOL isHiddenCancelButton;

//选择角色成功回调
@property (nonatomic, copy) SelRoleSuccessBlock selRoleSuccessBlock;

@end

@interface YZGPieLoopProgressView : UIView

- (void)startTimer;
- (void)endTimer;

- (id )initWithFrame:(CGRect)frame runRollSpeed:(CGFloat )runRollSpeed progressColor:(UIColor *)progressColor;

@property (nonatomic, assign) CGFloat progress;//进度
@property (nonatomic, assign) CGFloat runRollSpeed;//滚动速度
@property (nonatomic, strong) NSTimer *progressTimer;//定时器
@property (nonatomic, strong) UIColor *progressColor;//进度条颜色
@property (nonatomic, strong) UIColor *shadeColor;//遮罩颜色


@end

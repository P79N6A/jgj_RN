//
//  JGJBottomBtnView.h
//  JGJCompany
//
//  Created by Tony on 2017/12/12.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol JGJBottomBtnViewDelegate <NSObject>

- (void)clickJGJBottomBtnViewBtn;

@end
@interface JGJBottomBtnView : UIView
@property (strong, nonatomic) IBOutlet UIButton *clickBtn;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) id<JGJBottomBtnViewDelegate>delegate;

@property (assign, nonatomic) JGJNodataDefultModel *defultModel;

/*
 *直接返回
 */
+ (JGJBottomBtnView *)showBootmAndWithTitle:(NSString *)title andSuperView:(UIView *)view;
/*
 *设置标题
 */
- (void)setClickBtnTitle:(NSString *)title;

@end

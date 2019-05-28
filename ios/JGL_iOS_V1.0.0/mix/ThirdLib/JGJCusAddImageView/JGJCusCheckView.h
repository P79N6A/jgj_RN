//
//  JGJCusCheckView.h
//  mix
//
//  Created by YJ on 2019/1/6.
//  Copyright © 2019年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJCusCheckButton.h"

@class JGJCusCheckView;

@protocol JGJCusCheckViewDelegate <NSObject>

@optional

- (void)cusCheckView:(JGJCusCheckView *)checkView checkBtnPressed:(JGJCusCheckButton *)sender;

- (void)cusCheckView:(JGJCusCheckView *)checkView delBtnPressed:(JGJCusCheckButton *)sender;

@end

@interface JGJCusCheckView : UIView

//是选择图片类型
@property (nonatomic, assign) BOOL is_sel_photo;

@property (nonatomic, weak) id <JGJCusCheckViewDelegate> delegate;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong,readonly) JGJCusCheckButton *imageBtn;

@property (nonatomic, strong, readonly) JGJCusCheckButton *delBtn;

@end

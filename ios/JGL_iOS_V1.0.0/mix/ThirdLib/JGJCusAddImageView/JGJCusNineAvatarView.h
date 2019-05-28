//
//  JGJCusNineAvatarView.h
//  mix
//
//  Created by YJ on 2019/1/6.
//  Copyright © 2019年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJCusCheckView.h"

@class JGJCusNineAvatarView;

@protocol JGJCusNineAvatarViewDelegate <NSObject>

@optional

- (void)cusNineAvatarView:(JGJCusNineAvatarView *)avatarView checkView:(JGJCusCheckView *)checkView;

@end

@interface JGJCusNineAvatarView : UIView

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) NSInteger col;

@property (nonatomic, assign) NSInteger maxImageCount;

@property (nonatomic, strong) NSMutableArray *photos;

//是否显示添加按钮

@property (nonatomic, assign) BOOL isShowAddBtn;

//查看图片没有删除和添加按钮

@property (nonatomic, assign) BOOL isCheckImage;

@property (nonatomic, weak) id <JGJCusNineAvatarViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

//单个高度

+(CGFloat)avatarSingleViewHeight;

+(CGFloat)avatarViewHeightWithPhotoCount:(NSInteger)count;

@end

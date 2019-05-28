//
//  JGJNineAvatarCell.h
//  mix
//
//  Created by YJ on 2019/1/6.
//  Copyright © 2019年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJCusNineAvatarView.h"

@class JGJNineAvatarCell;

@protocol JGJNineAvatarCellDelegate <NSObject>

@optional

- (void)nineAvatarCell:(JGJNineAvatarCell *)cell avatarView:(JGJCusNineAvatarView *)avatarView checkView:(JGJCusCheckView *)checkView;

@end

@interface JGJNineAvatarCell : UITableViewCell

@property (strong, nonatomic,readonly) JGJCusNineAvatarView *avatarView;

@property (weak, nonatomic) id <JGJNineAvatarCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *photos;

//是否显示添加按钮

@property (nonatomic, assign) BOOL isShowAddBtn;

@property (nonatomic, assign) BOOL isCheckImage;

@end

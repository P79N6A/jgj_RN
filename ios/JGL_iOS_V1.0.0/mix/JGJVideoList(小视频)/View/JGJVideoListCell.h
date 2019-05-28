//
//  JGJVideoListCell.h
//  mix
//
//  Created by yj on 2018/3/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJVideoListModel.h"

@class JGJVideoListCell;

typedef enum : NSUInteger {
    JGJVideoListCellButtonDefaultType,
    
    JGJVideoListCellButtonComType,//评论
    
    JGJVideoListCellButtonPraiseType,//点赞
    
    JGJVideoListCellButtonShareType, //分享
    
    JGJVideoListCellButtonNameHeadType //头像
    
} JGJVideoListCellButtonType;

@protocol JGJVideoListCellDelegate <NSObject>

- (void)videoListCell:(JGJVideoListCell *)cell buttonType:(JGJVideoListCellButtonType)buttonType;

@end

@interface JGJVideoListCell : UITableViewCell

@property (nonatomic, strong) JGJVideoListModel *listModel;

/** 播放按钮block */
@property (nonatomic, copy  ) void(^playBlock)(UIButton *, JGJVideoListModel *);

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UIView *coverBottomView;

@property (weak, nonatomic) IBOutlet UIView *coverVideoView;

@property (assign, nonatomic) BOOL isVideoBlack;

@property (assign, nonatomic) BOOL isBottomBlack;

//重置视频
@property (nonatomic, assign) BOOL resetPlay;

@property (nonatomic, weak) id <JGJVideoListCellDelegate> delegate;

@end

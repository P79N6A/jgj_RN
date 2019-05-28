//
//  JGJChatListCellTopTimeView.h
//  mix
//
//  Created by Tony on 2016/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYModel.h"
#import "JGJChatListType.h"
#import "JGJChatMsgListModel.h"

@class JGJChatListCellTopTimeView,JGJChatListCellTopTimeModel;

@protocol TopTimeViewDelegate <NSObject>

- (void)topTimeViewSelected:(JGJChatListCellTopTimeView *)topTimeView;

@end

@interface JGJChatListCellTopTimeView : UIView
@property (nonatomic , weak) id<TopTimeViewDelegate> delegate;

@property (nonatomic, strong) JGJChatListCellTopTimeModel *topTimeModel;

@end

@interface JGJChatListCellTopTimeModel : TYModel

@property (nonatomic,copy) NSString *normalString;

@property (nonatomic,copy) NSString *highlightString;

@property (nonatomic,assign) JGJChatListBelongType belongType;

@property (nonatomic,assign) JGJChatListType listType;

@property (nonatomic,strong) JGJChatMsgListModel *chatMsgListModel;
@end
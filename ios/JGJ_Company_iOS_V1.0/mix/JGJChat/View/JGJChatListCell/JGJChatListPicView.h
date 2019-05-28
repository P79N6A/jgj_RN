//
//  JGJChatListPicView.h
//  JGJCompany
//
//  Created by Tony on 2016/12/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"

@class JGJChatListPicView;

//@protocol JGJChatListPicViewDelegate <NSObject>
//@optional
//
//- (void)sendMessageAgain:(JGJChatListPicView *)picCell indexPath:(NSIndexPath *)indexPath;
//
//- (void)downloadImage:(JGJChatListPicView *)picCell image:(UIImage *)image;
//
//- (void)didSelectedPicImage:(JGJChatListPicView *)picCell indexPath:(NSIndexPath *)indexPath;
//@end

@interface JGJChatListPicView : UIView

//@property (nonatomic , weak) id<JGJChatListPicViewDelegate> delegate;

@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,assign) JGJChatListSendType sendType;

@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;

@property (nonatomic,strong) UITableView *tableView;

- (void)startAnimating;

- (void)stopAnimating:(JGJChatListSendType)sendType;
@end

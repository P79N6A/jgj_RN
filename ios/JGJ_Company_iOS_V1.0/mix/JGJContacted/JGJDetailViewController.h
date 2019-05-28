//
//  JGJDetailViewController.h
//  mix
//
//  Created by Tony on 2016/12/30.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
#import "JGJSingerTextCollectionViewCell.h"
#import "JGJSingerNumCollectionViewCell.h"
#import "JGJSingerSelectTimeCollectionViewCell.h"
#import "JGJDoubleSelectTimeCollectionViewCell.h"
#import "JGJChoiceLogTextCollectionViewCell.h"
#import "JGJMoreLineTextCollectionViewCell.h"
#import "JGJHistoryText.h"
#import "JGJChatInputView.h"

#import "JGJDetailNoticesCollectionViewCell.h"

#import "JGJLableSize.h"

#import "UIPhotoViewController.h"

@interface JGJDetailViewController : UIPhotoViewController
@property(nonatomic,assign)BOOL IsClose;
@property(nonatomic,strong)UICollectionView *MainCollectionview;
@property (nonatomic,strong)JGJChatMsgListModel *jgjChatListModel;
@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;
@property (nonatomic,assign) BOOL taskDetail;
@property (nonatomic,strong) UIImageView *closeTeamImage;;
@property (nonatomic,strong) JGJLogDetailModel *logDeailModel;;
@property (nonatomic,assign)  BOOL ModifyLog;;
@property (nonatomic,assign)  BOOL chatRoomGo;//聊聊进入
@property (nonatomic,assign)  BOOL replyChat;//聊聊进入
@property (nonatomic,assign)  BOOL unRecived;//用于惦记了已收到按钮还是为反馈按钮
@property (nonatomic, strong) JGJChatInputView *chatInputView;

@end

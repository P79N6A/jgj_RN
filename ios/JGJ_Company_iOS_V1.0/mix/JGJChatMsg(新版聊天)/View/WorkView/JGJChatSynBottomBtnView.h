//
//  JGJChatSynCreatProBtnView.h
//  mix
//
//  Created by yj on 2018/7/31.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JGJChatSynCreatProBtnViewBlock)(JGJChatSynBtnType type,JGJChatMsgListModel *jgjChatListModel);
@interface JGJChatSynBottomBtnView : UIView

@property (nonatomic, copy) JGJChatSynCreatProBtnViewBlock actionBlock;

@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;

@end

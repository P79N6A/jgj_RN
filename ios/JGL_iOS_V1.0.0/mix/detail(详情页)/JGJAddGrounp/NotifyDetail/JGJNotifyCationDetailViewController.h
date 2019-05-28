//
//  JGJNotifyCationDetailViewController.h
//  mix
//
//  Created by Tony on 2016/12/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
@protocol InitUiDelegate<NSObject>
-(void)InitUiModel:(JGJChatMsgListModel *)model;

@end

@interface JGJNotifyCationDetailViewController : UIViewController
@property (nonatomic,strong)JGJChatMsgListModel *jgjChatListModel;
@property (nonatomic,retain)id <InitUiDelegate> Uidelegate;
@property (strong, nonatomic) IBOutlet UIButton *BottomButton;

@end

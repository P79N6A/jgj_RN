//
//  JGJChatMsgBaseCell.h
//  mix
//
//  Created by yj on 2018/7/30.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JGJBaseOutMsgView.h"

#import "JGJBaseMyMsgView.h"

#import "JGJCusYyLable.h"

#import "TYInputView.h"

#import "JGJChatListBaseCell.h"

@class JGJChatMsgBaseCell;
@class JGJChatSynInfoCell;
@protocol JGJChatMsgBaseCellDelegate<NSObject>

@optional

- (void)clickVoiceCellWithChatMsgModel:(JGJChatMsgListModel *)msgModel;

//菜单是否显示
- (void)chatListBaseCell:(JGJChatMsgBaseCell *)chatListCell showMenu:(BOOL)isShowMenu;

//菜单是否显示
- (void)chatListBaseCell:(JGJChatMsgBaseCell *)chatListCell showMenuType:(JGJShowMenuType)menuType;

- (void)chatSynInfoWithBtnType:(JGJChatSynBtnType)btnType jgjChatListModel:(JGJChatMsgListModel *)msgModel;

// 招聘小助手里面的 招工情况t查看详情跳转链接
- (void)tapRecruitmentSituationCellWithJumpUrl:(NSString *)jumpUrl;
@end

@interface JGJChatMsgBaseCell : UITableViewCell

@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;

@property (weak, nonatomic,readonly) IBOutlet JGJBaseOutMsgView *outMsgView;

@property (weak, nonatomic,readonly) IBOutlet JGJBaseMyMsgView *myMsgView;


@property (strong, nonatomic)  UIButton *headBtn;

@property (strong, nonatomic) JGJCusYyLable *contentLabel;

@property (strong, nonatomic)  UIImageView *popImageView;

@property (strong, nonatomic) JGJCusYyLable *date;

@property (nonatomic,strong) TYInputView *super_textView;

///**
// *  当前显示的所在行
// */
//@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<JGJChatMsgBaseCellDelegate> delegate;

/**
 *  长按手势
 */
-(void)addLongTapHandler;

//撤回
-(void)revocationClicked:(id)sender;

//删除
-(void)deleteClicked:(id)sender;

//重发
-(void)resendClick:(id)sender;

//复制
-(void)copyClick:(id)sender;

@end

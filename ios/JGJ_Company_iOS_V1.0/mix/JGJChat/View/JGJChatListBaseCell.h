//
//  JGJChatListBaseCell.h
//  mix
//
//  Created by Tony on 2016/8/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatMsgListModel.h"
#import "TYInputView.h"
#import "JGJTouchLabel.h"
#import "JGJChatListTool.h"
#import "JGJChatListType.h"
#import "UIImageView+WebCache.h"
#import "JGJChatListAudioButton.h"
#import "JGJChatListCellTopTimeView.h"

#define kChatListCollectionCellMargin ((TYIS_IPHONE_5_OR_LESS?1:3)*2.5)

@class JGJChatListBaseCell;
@protocol JGJChatListBaseCellDelegate <NSObject>
- (void)DidSelectedPhoto:(JGJChatListBaseCell *)chatListCell index:(NSInteger )index image:(UIImage *)image;

@optional
- (void)expandBtnClick:(JGJChatListBaseCell *)chatListCell index:(NSInteger )index;

- (void)detailNextBtnClick:(JGJChatListBaseCell *)chatListCell indexPath:(NSIndexPath *)indexPath;

- (void)modifyMsg:(JGJChatListBaseCell *)chatListCell indexPath:(NSIndexPath *)indexPath;

- (void)deleteMsg:(JGJChatListBaseCell *)chatListCell indexPath:(NSIndexPath *)indexPath;

- (void)reSendMsg:(JGJChatListBaseCell *)chatListCell indexPath:(NSIndexPath *)indexPath;

- (void)longTouchAvatar:(JGJChatListBaseCell *)chatListCell;
//yj添加进入个人详情页
- (void)tapTouchAvatar:(JGJChatListBaseCell *)chatListCell;

//菜单是否显示
- (void)chatListBaseCell:(JGJChatListBaseCell *)chatListCell showMenu:(BOOL)isShowMenu;


//菜单显示样式
- (void)chatListBaseCell:(JGJChatListBaseCell *)chatListCell showMenuType:(JGJShowMenuType)menuType;

//自定义图片撤回样式，用于控制器滑动消失当前撤回 cusMenuBtn

- (void)chatListBaseCell:(JGJChatListBaseCell *)chatListCell cusMenuBtn:(UIButton *)cusMenuBtn;

// 转发消息
- (void)forwardChatListModelWithBaseCell:(JGJChatListBaseCell *)chatListCell;

@end

@interface JGJChatListBaseCell : UITableViewCell
@property (nonatomic , weak) id<JGJChatListBaseCellDelegate> delegate;

@property (nonatomic,strong) JGJChatMsgListModel *jgjChatListModel;

@property (nonatomic,strong) NSIndexPath *indexPath;

//collectionCell高宽
@property (nonatomic, assign) CGFloat collectionCellWH;

@property (nonatomic, assign) CGFloat contentLabelMaxW;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

//collectionView,放照片的
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//内容
@property (weak, nonatomic) IBOutlet JGJTouchLabel *contentLabel;

@property (weak, nonatomic) IBOutlet JGJChatListAudioButton *audioButton;

//显示时间的
@property (weak, nonatomic) IBOutlet JGJChatListCellTopTimeView *topTitleView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewConstraintB;

@property (nonatomic,strong) TYInputView *super_textView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) JGJLogSectionListModel *logModel;


/**
 *  子类用的
 */
- (void)subClassInit;

/**
 *  子类用来设置新版日志
 */
- (void)subLogClassWithModel:(JGJLogSectionListModel *)jgjChatListModel;

/**
 *  子类通过model进行设置
 *
 */
- (void)subClassSetWithModel:(JGJChatMsgListModel *)jgjChatListModel;

/**
 *  设置cellType的约束
 */
- (void)setCellTypeViewConstant:(CGFloat )constant;

/**
 *  设置collectionView的约束
 */
- (void)setCollectionViewHConstant:(CGFloat )constant;

/**
 *  设置collectionView的底部约束
 */
- (void)setCollectionViewBConstant:(CGFloat )constant;

/**
 *  发送消息
 */
- (void)sendMessageStart;

/**
 *  发送成功
 */
- (void)sendMessageSuccess;

/**
 *  发送失败
 */
- (void)sendMessageFail;

/**
 *  设置图片
 */
- (void)setCollectionImgs:(NSInteger )imgsCount chatListType:(JGJChatListType) chatListType;

- (BOOL )filterSubClassSetCollectionImgs:(NSInteger )imgsCount chatListType:(JGJChatListType) chatListType;

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

//重发失败的消息
- (void)resendFailMsgClick;

/** 转发 */
- (void)forwardClick:(id)sender;

@end


@interface JGJChatDetailNextButton : UIButton

@property (nonatomic,copy) NSDictionary *chatTypeDic;

@property (nonatomic,assign) JGJChatListType chatListType;

@end

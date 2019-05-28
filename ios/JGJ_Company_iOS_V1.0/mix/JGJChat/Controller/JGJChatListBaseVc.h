//
//  JGJChatListBaseVc.h
//  mix
//
//  Created by Tony on 2016/8/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGJChatListBaseCell.h"
#import "JGJChatOtherListell.h"
#import "JGJChatListAllDetailVc.h"
#import "JGJChatNoDataDefaultView.h"
#import "JGJChatListOtherCell.h"

#import "MJRefresh.h"
#import "NSString+JSON.h"
#import "JGJChatRootVc.h"
#import "JGJChatListTool.h"
#import "LZChatRefreshHeader.h"
#import "UITableViewCell+Extend.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "JGJCusAddMediaView.h"

#define UseTableView_FDTHeight YES

typedef void(^skipToNextVc)(UIViewController *nextVc);

@class JGJChatListBaseCell,JGJChatListBaseVc;
@protocol JGJChatListBaseVcDelegate <NSObject>

- (void)chatListVc:(JGJChatListBaseVc *)listVc selectedPhoto:(id )chatListCell index:(NSInteger )index image:(UIImage *)image;

- (void)chatListVc:(JGJChatListBaseVc *)listVc readMessage:(NSDictionary *)readMessage;

- (void)chatListVc:(JGJChatListBaseVc *)listVc sendPic:(NSDictionary *)readMessage;

- (void)chatListVc:(JGJChatListBaseVc *)listVc seletctedPicCell:(NSIndexPath *)indexPath;

- (void)chatListVcRefresh:(JGJChatListBaseVc *)listVc;
@end

@interface JGJChatListBaseVc : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate,
    TopTimeViewDelegate,
    JGJChatListBaseCellDelegate
>
{
    
    JGJChatListOtherCell *_currentVoiceCell;
    JGJChatListOtherCell *_lastVoiceCell;
}
@property (nonatomic , weak) id<JGJChatListBaseVcDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *dataSourceArray;

@property (nonatomic, strong) NSMutableArray *muSendMsgArray; //发送的消息模型保存，用于遍历自己发送的消息

@property (nonatomic,copy) skipToNextVc skipToNextVc;

@property (nonatomic,copy) NSString *msgType;

@property (nonatomic,strong) IBOutlet UITableView *tableView;

@property (nonatomic,strong) JGJMyWorkCircleProListModel *workProListModel;

@property (nonatomic,copy) NSString *group_name;

@property (nonatomic,copy) NSString *nembers_num;

@property (nonatomic,weak) JGJChatRootVc *parentVc;

//保存成员信息，发送消息以后先用这种默认的
@property (nonatomic,strong) ChatMsgList_Read_info *read_info;

@property (nonatomic, strong) AudioRecordingServices *audioRecordingServices;

/**
 *  需要请求服务器的model
 */
@property (nonatomic,strong) JGJChatRootRequestModel *chatListRequestModel;

@property (nonatomic,strong) JGJChatNoDataDefaultView *chatNoDataDefaultView;

//聊天选择的图片PHAsset3.4添加
@property (nonatomic, strong) NSArray *chatSelAssets;

//相册、拍照、我的名片底部View
@property (strong, nonatomic) JGJCusAddMediaView *mediaView;

/**
 *  2.1.2-yj当前页面类型
 */
@property (nonatomic,assign) JGJChatListType vcType;

/**
 *  找工从在找帮手、找工作等项目信息带过来的信息组成的消息
 */
@property (nonatomic, strong) JGJChatMsgListModel *findJobTemporaryMsgModel;

@property (nonatomic, strong) NSMutableArray *messageReadedToSenderTask; //未读人数消息

/**
 *  是否显示键盘，用于消息的偏移计算。
 */
@property (nonatomic, assign) BOOL isCanScroBottom;

//菜单栏是否显示，显示当前页面滚动，隐藏则不影响
@property (nonatomic, assign) BOOL isMenuShow;

@property (nonatomic, strong, readonly) UIImageView *clocedImageView;

// 下拉的消息表示已读，回执给服务器
- (void)readedPullMsgs:(NSArray *)msgs;

- (void)subClassLoadData;

- (void)subClassLoadData:(void (^)(void))subClassBlock;

- (void)addSourceArr:(NSArray *)dataSourceArr;

/**
 *  给数据源添加数组数据
 *  add:是否需要添加到self.dataSourceArr,YES:添加，NO,不添加
 *  add:不添加的情况一般就是从外面排好序了
 */
- (void)addDataSourceArr:(NSArray *)dataSourceArr isAdd:(BOOL )add;

/**
 *  给数据源添加单个数据
 */
- (void)addSourceArrWith:(JGJChatMsgListModel *)msgListModel;

/**
 *  接收数据源添加单个数据
 */
- (void)addReceiveSourceArrWith:(JGJChatMsgListModel *)msgListModel;

/**
 *  直接替换，不需要索引
 */
- (void)replaceSourceArrObject:(JGJChatMsgListModel *)chatMsgListModel;

/**
 *  替换数据
 *
 *  @param chatMsgListModel 替换的数据
 *  @param index            替换的索引
 */
- (void)replaceSourceArrObject:(JGJChatMsgListModel *)chatMsgListModel index:(NSUInteger )index;

/**
 *  删除发送失败的数据
 *
 *  @param chatMsgListModel 删除的数据
 *  @param index            删除的索引
 */
- (void)deleteSourceArrObject:(JGJChatMsgListModel *)chatMsgListModel index:(NSUInteger )index;

/**
 *  已读的数据
 *
 *  @param chatMsgListModel 传入已读的数据，主要是msg_id,read_info
 */
- (void)readedMsgWith:(JGJChatMsgListModel *)chatMsgListModel;

/**
 *  添加文字消息
 *
 *  @param textStr 文字内容
 */
- (void)addTextMessage:(NSString *)textStr at_uid:(NSString *)at_uid;

/**
 *  增加语音内容
 *
 *  @param audioInfo 语音内容
 */
- (void)addAudioMessage:(NSDictionary *)audioInfo;

/**
 *  增加通知类内容
 *
 *  @param dataInfo 传入的字典
 */
- (void)addAllNotice:(NSDictionary *)dataInfo;

/**
 *  增加图片内容
 *
 *  @param dataInfo 传入的图片
 */
- (void)addPicMessage:(NSArray *)imagesArr;

/**
 *  配置通知
 */
- (JGJChatMsgListModel *)cofigAllNotice:(NSDictionary *)dataInfo;

/**
 *  添加通用参数
 */
- (JGJChatMsgListModel *)cofigMineCommonData:(JGJChatMsgListModel *)listModel;

/**
 *  配置参数
 */
- (NSDictionary *)configParameters:(JGJChatMsgListModel *)listModel;

/**
 *  数据初始化
 */
- (void)dataInit;

#pragma mark - 过滤数据
/**
 *  根据传入的类型过滤其他数据，比如传入JGJChatListNotice，则只需要JGJChatListNotice的数据
 *
 *  @param chatListType 消息类型
 */
- (void)filterByChatListType:(JGJChatListType )chatListType;

/**
 *  tableView滑动到最底部
 */
- (void)tableViewToBottom;

/**
 *  上划的操作
 */
- (void)chatListLoadUpData;

/**
 *  显示对应类型的示例数据
 *  返回:YES，是示例数据，NO，不是示例数据
 */
- (BOOL )showExampleDataByType:(JGJChatListType )chatListType;

- (void)messageReaded:(JGJChatMsgListModel *)chatListModel indexPath:(NSIndexPath *)indexPath;

/**
 *  没有数据的界面
 */
- (void )noDataDefaultView;

- (void )noDataDefaultView:(NSInteger )dataCout;

/**
 *  给子类使用来设置baseCell的super_textView
 */
- (void)setSuper_textView:(JGJChatListBaseCell *)baseCell;

/**
 *  屏幕上的cell调用已读相关的接口
 */
- (void)loadVisibleCellsMessageRead;

//读消息
- (void)messageReaded:(NSIndexPath *)indexPath chatListModel:(JGJChatMsgListModel *)chatListModel;

/*
 * 停止播放 //2.1.0-yj
 */
- (void)audioStopPlay;

//  拼接未读数据
- (void)messageReadedChatListModels:(NSArray *)chatListModels;

//未读人数处理

- (void)freshMyMsgUnreadNum:(NSArray *)myMsgs;

/*
 *发送消息
 */
- (void)sendMsgToServicer:(JGJChatMsgListModel *)listModel;

@end

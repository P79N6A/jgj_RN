
//
//  JGJConversationSelectionVc.m
//  mix
//
//  Created by Json on 2019/3/26.
//  Copyright © 2019 JiZhi. All rights reserved.
//

#import "JGJConversationSelectionVc.h"
#import "TYTextField.h"
#import "JGJConversationSelectionBottomView.h"
#import "JGJSelectedConversationCell.h"
#import "JGJChatMsgDBManger.h"
#import "JGJChatGroupListModel.h"
#import "JGJConversationHeaderView.h"
#import "JGJMsgSendAlertView.h"
#import "JGJSendMessageTool.h"


static NSString * const selectedConversationCellId = @"JGJSelectedConversationCell";
static NSString * const conversationHeaderViewId = @"JGJConversationHeaderView";
static CGFloat const bottomViewH = 60.0f;

@interface JGJConversationSelectionVc ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, weak) JGJCustomSearchBar *searchBar;
@property (nonatomic, weak) JGJConversationSelectionBottomView *bottomView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *multiSelectionItem;
@property (nonatomic, strong) UIBarButtonItem *cancelItem;

/**
 聊天(会话),数据源
 */
@property (nonatomic, strong) NSArray *conversations;

/**
 所有聊天(会话)
 */
@property (nonatomic, strong) NSArray *allConversations;
/**
 多选状态下选中的会话
 */
@property (nonatomic, strong) NSMutableArray *selectedConversations;



@end

@implementation JGJConversationSelectionVc

#pragma mark - Lazy Loading

- (UIBarButtonItem *)multiSelectionItem
{
    if (!_multiSelectionItem) {
        _multiSelectionItem = [[UIBarButtonItem alloc] initWithTitle:@"多选" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightButtonItemClick)];
    }
    return _multiSelectionItem;
}
- (UIBarButtonItem *)cancelItem
{
    if (!_cancelItem) {
        _cancelItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bclosed"] style:(UIBarButtonItemStyleDone) target:self action:@selector(leftButtonItemClick)];
    }
    return _cancelItem;
}

- (NSMutableArray *)selectedConversations
{
    if (!_selectedConversations) {
        _selectedConversations = [NSMutableArray array];
    }
    return _selectedConversations;
}

#pragma mark - Life Circle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    self.allConversations = [JGJChatMsgDBManger getCurrentGroupAndTeamAndGroupChatAndSingleChatList];
    self.conversations = self.allConversations;
    
    // 测试代码
    
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    CGFloat bottomInset = self.view.safeAreaInsets.bottom;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-bottomInset);
    }];
}

#pragma mark - UI界面

- (void)commonInit {
    [self initNavigationBar];
    [self initSearchBar];
    [self initBottomView];
    [self initTableView];
}

- (void)initNavigationBar {
    self.view.backgroundColor = AppFontf1f1f1Color;
    self.navigationItem.title = @"选择一个聊天";
    self.navigationItem.leftBarButtonItem = self.cancelItem;
    self.navigationItem.rightBarButtonItem = self.multiSelectionItem;
    
}

- (void)initSearchBar {
    JGJCustomSearchBar *searchBar = [[JGJCustomSearchBar alloc] init];
    searchBar.searchBarTF.placeholder = @"输入姓名查找";
    searchBar.searchBarTF.maxLength = 20;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    CGFloat searchBarH = 49.0f;
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.height.mas_equalTo(searchBarH);
        make.top.mas_equalTo(self.view);
    }];
    // 监听输入框文字输入
    __weak typeof (self) weakSelf = self;
    searchBar.searchBarTF.valueDidChange = ^(NSString *value) {
        __strong JGJConversationSelectionVc *strongSelf = weakSelf;
        if ([NSString isEmpty:value]) {
            strongSelf.conversations = strongSelf.allConversations;
        } else {
            NSString *lowerSearchText = value.lowercaseString;
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group_name contains %@", lowerSearchText];
            strongSelf.conversations = [strongSelf.allConversations filteredArrayUsingPredicate:predicate];
        }
        [strongSelf.tableView reloadData];
    };
}

- (void)initBottomView {
    JGJConversationSelectionBottomView *bottomView = [JGJConversationSelectionBottomView bottomView];
    bottomView.backgroundColor = AppFontffffffColor;
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(0);
    }];
    
    self.bottomView.hidden = YES;
    
    __weak typeof(self) weakSelf = self;
    self.bottomView.ensureAction = ^{
        
        __strong JGJConversationSelectionVc *strongSelf = weakSelf;
        
        if (strongSelf.selectedConversations.count == 0) { return; }
        // 弹出alertView
        JGJMsgSendAlertView *alertView = [[JGJMsgSendAlertView alloc] init];
        alertView.showSendNumber = YES;
        alertView.conversations = [strongSelf.selectedConversations copy];
        alertView.message = strongSelf.message;
        [alertView show];
        
        // 点击alertView发送按钮
        __weak typeof(alertView) weakAlertView = alertView;
        alertView.ensureAction = ^{
            
            TYLog(@"点击了发送按钮");
            __strong JGJMsgSendAlertView *strongAlertView = weakAlertView;
            
            NSMutableArray *messages = [NSMutableArray array];
            // 其他消息
            if (strongSelf.message.chatListType == JGJChatListPic) {
                // 不带URL的图片
                if (strongSelf.message.msg_src.count == 0 && strongSelf.message.picImage) {
                    // 上传图片
                    [JGJSendMessageTool uploadImages:@[strongSelf.message.picImage] success:^(NSArray *urls) {
                        // 构建图片消息
                        for (JGJChatGroupListModel *conversation in strongSelf.selectedConversations) {
                            JGJChatMsgListModel *message = [self createImageMessage:urls picWH:strongSelf.message.pic_w_h groupId:conversation.group_id classType:conversation.class_type isSource:strongSelf.message.is_source memNum:conversation.members_num];
                            [messages addObject:message];
                        }
                        // 构建留言消息
                        if (![NSString isEmpty:strongAlertView.leftMessage]) {
                            for (JGJChatGroupListModel *conversation in strongSelf.selectedConversations) {
                                // 构建文本消息(留言)
                                JGJChatMsgListModel *message = [self createTextMessage:strongAlertView.leftMessage groupId:conversation.group_id classType:conversation.class_type isSource:strongSelf.message.is_source memNum:conversation.members_num];
                                [messages addObject:message];
                            }
                        }
                        // 发送消息
                        [JGJSendMessageTool sendMsgs:messages successBlock:^(JGJChatMsgListModel *msgModel) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageSendSuccessedNotification object:msgModel];
                        }];
                        [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageDidSendNotification object:messages];

                        [strongSelf dismissViewControllerAnimated:YES completion:nil];
                        [TYShowMessage showSuccess:@"已发送"];
                        
                    } failure:^(NSError *error) {
                        // 构建留言消息
                        if (![NSString isEmpty:strongAlertView.leftMessage]) {
                            for (JGJChatGroupListModel *conversation in strongSelf.selectedConversations) {
                                // 构建文本消息(留言)
                                JGJChatMsgListModel *message = [self createTextMessage:strongAlertView.leftMessage groupId:conversation.group_id classType:conversation.class_type isSource:strongSelf.message.is_source memNum:conversation.members_num];
                                [messages addObject:message];
                            }
                        }
                        // 发送消息
                        [JGJSendMessageTool sendMsgs:messages successBlock:^(JGJChatMsgListModel *msgModel) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageSendSuccessedNotification object:msgModel];
                        }];
                        [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageDidSendNotification object:messages];

                        [strongSelf dismissViewControllerAnimated:YES completion:nil];
                        [TYShowMessage showSuccess:@"已发送"];
                    }];
                    return;
                }
            }
            
            // 构建其他消息
            for (JGJChatGroupListModel *conversation in strongSelf.selectedConversations) {
                JGJChatMsgListModel *message = [self createMessageWithType:strongSelf.message.msg_type msgText:strongSelf.message.msg_text msgSrc:strongSelf.message.msg_src picWH:strongSelf.message.pic_w_h msgTextOther:strongSelf.message.msg_text_other groupId:conversation.group_id classType:conversation.class_type isSource:strongSelf.message.is_source memNum:conversation.members_num];
                [messages addObject:message];
            }
            // 构建留言消息
            if (![NSString isEmpty:strongAlertView.leftMessage]) {
                for (JGJChatGroupListModel *conversation in strongSelf.selectedConversations) {
                    // 构建文本消息(留言)
                    JGJChatMsgListModel *message = [self createTextMessage:strongAlertView.leftMessage groupId:conversation.group_id classType:conversation.class_type isSource:strongSelf.message.is_source memNum:conversation.members_num];
                    [messages addObject:message];
                }
            }
            // 发送所有消息
            [JGJSendMessageTool sendMsgs:messages successBlock:^(JGJChatMsgListModel *msgModel) {
                [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageSendSuccessedNotification object:msgModel];
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageDidSendNotification object:messages];

            // dismiss
            [strongSelf dismissViewControllerAnimated:YES completion:nil];
            [TYShowMessage showSuccess:@"已发送"];
        };
        
    };
}

- (void)initTableView {
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = AppFontf1f1f1Color;
    tableView.tableFooterView = [[UIView alloc] init];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.searchBar.mas_bottom);
        make.bottom.mas_equalTo(self.bottomView.mas_top);
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([JGJSelectedConversationCell class]) bundle:nil] forCellReuseIdentifier:selectedConversationCellId];
    [self.tableView registerClass:[JGJConversationHeaderView class] forHeaderFooterViewReuseIdentifier:conversationHeaderViewId];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}

#pragma mark - Button action
/**
 点击取消/关闭按钮
 */
- (void)leftButtonItemClick {
    if (self.tableView.allowsMultipleSelection) {// 如果当前为多选状态
        // 进入单选状态
        
        self.navigationItem.rightBarButtonItem = self.multiSelectionItem;
        self.navigationItem.title = @"选择一个聊天";
        
        self.bottomView.hidden = YES;
        [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        
        self.tableView.allowsMultipleSelection = NO;
        
        
        // 重置selectedConversations数组中模型is_selected为NO,并刷新
//        [self.selectedConversations makeObjectsPerformSelector:@selector(setIs_selected:) withObject:@(NO)];
        for (JGJChatGroupListModel *con in self.selectedConversations) {
            con.is_selected = NO;
        }
        
        [self.tableView reloadData];
        
        // 清除selectedConversations数组
        [self.selectedConversations removeAllObjects];
        [self updateBottomViewContent];
        
    } else {
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

/**
 点击多选按钮
 */
- (void)rightButtonItemClick {
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.title = @"选择多个聊天";
    self.bottomView.hidden = NO;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(bottomViewH);
    }];
    [self.selectedConversations removeAllObjects];
    self.tableView.allowsMultipleSelection = YES;
    [self.tableView reloadData];
}

- (void)sendButtonClick
{
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJSelectedConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedConversationCellId forIndexPath:indexPath];
    cell.edited = self.tableView.allowsMultipleSelection;
    cell.searchKeyword = self.searchBar.searchBarTF.text;
    JGJChatGroupListModel *conversation = self.conversations[indexPath.row];
    cell.conversation = conversation;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJChatGroupListModel *conversation = self.conversations[indexPath.row];
    if (self.tableView.allowsMultipleSelection) {
        /** 多选 */
        if (self.selectedConversations.count >= 9 && conversation.is_selected == NO) {
            [TYShowMessage showPlaint:@"最多只能选择9个聊天"];
            return;
        }
        // 选中/取消选中,刷新
        conversation.is_selected = !conversation.is_selected;
        if (conversation.is_selected) {
            [self.selectedConversations addObject:conversation];
        } else {
            [self.selectedConversations removeObject:conversation];
        }
        //        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationNone)];
        [self.tableView reloadData];
        
        // 更新底部控件显示
        [self updateBottomViewContent];
        
    } else {
        /** 单选 */
        
        // 如果键盘处于弹出状态,退掉键盘
        [self.view endEditing:YES];
        
        // 先清空当前选中的会话,然后添加现在选中会话
        [self.selectedConversations removeAllObjects];
        [self.selectedConversations addObject:conversation];
        
        // 弹出alertView
        JGJMsgSendAlertView *alertView = [[JGJMsgSendAlertView alloc] init];
        alertView.message = self.message;
        alertView.conversations = [self.selectedConversations copy];
        [alertView show];
        
        // 点击alertView发送按钮
        __weak typeof(self) weakSelf = self;
        __weak typeof(alertView) weakAlertView = alertView;
        
        alertView.ensureAction = ^{
            TYLog(@"点击了发送按钮");
            __strong JGJConversationSelectionVc *strongSelf = weakSelf;
            __strong JGJMsgSendAlertView *strongAlertView = weakAlertView;
            
            NSString *groudId = conversation.group_id;
            NSString *classType = conversation.class_type;
            
            NSMutableArray *messages = [NSMutableArray array];
            
            // 不带URL的图片消息
            if (strongSelf.message.chatListType == JGJChatListPic) {
                // 不带URL的图片消息
                if (strongSelf.message.msg_src.count == 0 && strongSelf.message.picImage) {
                    // 上传图片
                    [JGJSendMessageTool uploadImages:@[strongSelf.message.picImage] success:^(NSArray *urls) {
                        // 构建图片消息
                        JGJChatMsgListModel *message = [self createImageMessage:urls picWH:strongSelf.message.pic_w_h groupId:groudId classType:classType isSource:strongSelf.message.is_source memNum:conversation.members_num];
                        [messages addObject:message];
                        // 构建文本消息(留言)
                        if (![NSString isEmpty:strongAlertView.leftMessage]) {
                            JGJChatMsgListModel *message = [self createTextMessage:strongAlertView.leftMessage groupId:groudId classType:classType isSource:strongSelf.message.is_source memNum:conversation.members_num];
                            [messages addObject:message];
                        }
                        [JGJSendMessageTool sendMsgs:messages successBlock:^(JGJChatMsgListModel *msgModel) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageSendSuccessedNotification object:msgModel];
                        }];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageDidSendNotification object:messages];

                        [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                        [TYShowMessage showSuccess:@"已发送"];
                        
                    } failure:^(NSError *error) {
                        // 构建文本消息(留言)
                        if (![NSString isEmpty:strongAlertView.leftMessage]) {
                            JGJChatMsgListModel *message = [self createTextMessage:strongAlertView.leftMessage groupId:groudId classType:classType isSource:strongSelf.message.is_source memNum:conversation.members_num];
                            [messages addObject:message];
                        }
                        // 发送文本消息
                        if (messages.count) {
                            [JGJSendMessageTool sendMsgs:messages successBlock:^(JGJChatMsgListModel *msgModel) {
                                [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageSendSuccessedNotification object:msgModel];
                            }];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageDidSendNotification object:messages];

                        }
                        [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
                        [TYShowMessage showSuccess:@"已发送"];
                    }];
                    
                    return;
                }
                
            }
            // 其他类型消息
            JGJChatMsgListModel *message = [self createMessageWithType:strongSelf.message.msg_type msgText:strongSelf.message.msg_text msgSrc:strongSelf.message.msg_src picWH:strongSelf.message.pic_w_h msgTextOther:strongSelf.message.msg_text_other groupId:conversation.group_id classType:conversation.class_type isSource:strongSelf.message.is_source memNum:conversation.members_num];
            [messages addObject:message];
            
            // 构建文本消息(留言)
            if (![NSString isEmpty:strongAlertView.leftMessage]) {
                JGJChatMsgListModel *message = [self createTextMessage:strongAlertView.leftMessage groupId:groudId classType:classType isSource:strongSelf.message.is_source memNum:conversation.members_num];
                [messages addObject:message];
            }
            
            [JGJSendMessageTool sendMsgs:messages successBlock:^(JGJChatMsgListModel *msgModel) {
                [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageSendSuccessedNotification object:msgModel];
            }];
            [[NSNotificationCenter defaultCenter] postNotificationName:JGJConversationSelectionVcMessageDidSendNotification object:messages];

            // dismiss
            [strongSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
            [TYShowMessage showSuccess:@"已发送"];
        };
        
        
        alertView.cancelAction = ^{
            TYLog(@"点击了取消按钮");
        };
        
    }
}

#pragma mark - 构建消息
/**
 构建文本消息
 */
- (JGJChatMsgListModel *)createTextMessage:(NSString *)text groupId:(NSString *)groupId classType:(NSString *)classType isSource:(NSInteger)isSource memNum:(NSString *)memNum
{
    JGJChatMsgListModel *message = [self createMessageWithType:@"text" msgText:text msgSrc:nil picWH:nil msgTextOther:nil groupId:groupId classType:classType isSource:isSource memNum:memNum];
    return  message;
    
    //    JGJChatMsgListModel *message = [[JGJChatMsgListModel alloc] init];
    //    message.msg_type = @"text";
    //    message.msg_text = strongAlertView.leftMessage;
    //    message.group_id = groudId;
    //    message.class_type = classType;
    //    message.members_num = conversation.members_num;
    //    message.is_source = strongSelf.message.is_source;
}

/**
 构建图片消息
 */
- (JGJChatMsgListModel *)createImageMessage:(NSArray *)urls picWH:(NSArray *)pic_w_h groupId:(NSString *)groupId classType:(NSString *)classType isSource:(NSInteger)isSource memNum:(NSString *)memNum
{
    
    JGJChatMsgListModel *message = [self createMessageWithType:@"pic" msgText:nil msgSrc:urls picWH:pic_w_h msgTextOther:nil groupId:groupId classType:classType isSource:isSource memNum:(memNum)];
    
    return  message;
    
    // 构建图片消息
    //    JGJChatMsgListModel *message = [[JGJChatMsgListModel alloc] init];
    //    message.group_id = conversation.group_id;
    //    message.class_type = conversation.class_type;
    //    message.members_num = conversation.members_num;
    //    message.msg_type = @"pic";
    //    message.msg_src = urls;
    //    message.pic_w_h = strongSelf.message.pic_w_h;
    //    message.is_source = strongSelf.message.is_source;
    //    [messages addObject:message];
}
/**
 构建任意类型消息
 */
- (JGJChatMsgListModel *)createMessageWithType:(NSString *)msgType msgText:(NSString *)msgText msgSrc:(NSArray *)msgSrc picWH:(NSArray *)pic_w_h msgTextOther:(NSString *)msg_text_other groupId:(NSString *)groupId classType:(NSString *)classType isSource:(NSInteger)isSource memNum:(NSString *)memNum
{
    // 构建任意消息
    JGJChatMsgListModel *message = [[JGJChatMsgListModel alloc] init];
    
    // 消息体
    message.msg_src = msgSrc;
    message.msg_text = msgText;
    message.msg_text_other = msg_text_other;
    message.pic_w_h = pic_w_h;
    // 必须参数
    message.msg_type = msgType;
    message.group_id = groupId;
    message.class_type = classType;
    message.members_num = memNum;
    message.is_source = isSource;
    return  message;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    JGJConversationHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:conversationHeaderViewId];
    headerView.title = @"最近聊天";
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}

/**
 更新底部控件显示
 */
- (void)updateBottomViewContent
{
    NSInteger chatGroupNum = 0;
    NSInteger singleChatNum = 0;
    for (JGJChatGroupListModel *conversation in self.selectedConversations) {
        if ([conversation.class_type isEqualToString:@"singleChat"]) {
            singleChatNum += 1;
        } else {
            chatGroupNum += 1;
        }
    }
    NSString *singleChatContent = (singleChatNum != 0) ? [NSString stringWithFormat:@"%zd人",singleChatNum] : nil;
    NSString *chatGroupContent = (chatGroupNum != 0) ? [NSString stringWithFormat:@"%zd群组",chatGroupNum] : nil;
    NSString *content;
    if (chatGroupNum) {
        if (singleChatNum) {
            content = [NSString stringWithFormat:@"%zd人,%zd群组",singleChatNum,chatGroupNum];
        } else {
            content = [NSString stringWithFormat:@"%zd群组",chatGroupNum];
        }
    } else {
        if (singleChatNum) {
            content = [NSString stringWithFormat:@"%zd人",singleChatNum];
        } else {
            content = @" ";
        }
    }
    self.bottomView.content = content;
    self.bottomView.buttonEnable = ((chatGroupNum + singleChatNum) != 0);
}

@end


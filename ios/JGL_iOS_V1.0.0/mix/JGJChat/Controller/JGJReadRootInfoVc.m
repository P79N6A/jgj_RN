//
//  JGJReadRootInfoVc.m
//  mix
//
//  Created by Tony on 2016/9/2.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJReadRootInfoVc.h"
#import "TYBaseTool.h"
#import "SegmentTapView.h"
#import "MultipleChoiceTableView.h"
#import "JGJReadedInfoVc.h"
#import "JGJUnreadInfoVc.h"

static const NSInteger kJGJReadInfoVcSegmentY = 0;
static const NSInteger kJGJReadInfoVcSegmentH = 40;

@interface JGJReadRootInfoVc ()
<
    SegmentTapViewDelegate,
    MultipleChoiceTableViewDelegate
>

//标题数组
@property(strong, nonatomic) NSArray<NSString *> *titles;

//子Vc数组
@property(strong, nonatomic) NSMutableArray<UIViewController *> *childVcs;

@property (strong, nonatomic) SegmentTapView *segmentTapView;

@property (strong, nonatomic) MultipleChoiceTableView *mulChoiceView;

@property (nonatomic, strong) ChatMsgList_Read_info *read_info;

@property (nonatomic, strong) JGJUnreadInfoVc *unreadInfoVc;

@property (nonatomic, strong) JGJReadedInfoVc *readedInfoVc;

@end

@implementation JGJReadRootInfoVc

- (void)viewDidLoad {
    [super viewDidLoad];

    [self commonSet];
    
    [self SegmentTapView];
    
    [self messageReadedWithChatListModel:self.chatMsgListModel type:@"unread"];
    
}

- (void )commonSet{
    self.title = @"消息接收人列表";

    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.view.backgroundColor = AppFontf1f1f1Color;
    
}

- (void)SegmentTapView{
    if ([self.view.subviews containsObject:self.segmentTapView]) {
        return;
    }
    self.titles = @[@"未读",@"已读"];
    self.segmentTapView = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, kJGJReadInfoVcSegmentY, TYGetUIScreenWidth, kJGJReadInfoVcSegmentH) withDataArray:self.titles withFont:15.0 isNormalFont:YES];
    
    self.segmentTapView.delegate = self;
    self.segmentTapView.backgroundColor = TYColorHex(0xfafafa);
    self.segmentTapView.textSelectedColor = JGJMainColor;
    self.segmentTapView.textNomalColor = TYColorHex(0x999999);
    self.segmentTapView.lineColor = JGJMainColor;
    self.segmentTapView.is_unEnable_scro = YES;
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = AppFontdbdbdbColor;
    [self.segmentTapView addSubview:topLineView];
    [topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.segmentTapView);
        make.width.mas_equalTo(TYGetUIScreenWidth);
        make.height.mas_equalTo(0.5);
    }];

    
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = AppFontdbdbdbColor;
    [self.segmentTapView addSubview:bottomLineView];
    [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.segmentTapView);
        make.width.mas_equalTo(TYGetUIScreenWidth);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.view addSubview:self.segmentTapView];
}

-(void)MultipleChoiceTableView{
    if ([self.view.subviews containsObject:self.mulChoiceView]) {
        return;
    }
    self.childVcs = [[NSMutableArray alloc] init];
    
//    //添加子控制器
    JGJUnreadInfoVc *unreadInfoVc = [JGJUnreadInfoVc new];
    
    self.unreadInfoVc = unreadInfoVc;
    
    JGJReadedInfoVc *readedInfoVc = [JGJReadedInfoVc new];
    
    self.readedInfoVc = readedInfoVc;

    [self addChildViewController:unreadInfoVc];
    
    [self addChildViewController:readedInfoVc];
    
    [self.childVcs addObject:unreadInfoVc];
    
    [self.childVcs addObject:readedInfoVc];

    unreadInfoVc.dataSourceArr = self.read_info.unread_user_list.mutableCopy;
    
    readedInfoVc.dataSourceArr = self.read_info.readed_user_list.mutableCopy;
    
    CGFloat mulChoiceY = kJGJReadInfoVcSegmentY + kJGJReadInfoVcSegmentH;
    self.mulChoiceView = [[MultipleChoiceTableView alloc] initWithFrame:CGRectMake(0, mulChoiceY, TYGetUIScreenWidth, TYGetUIScreenHeight - mulChoiceY - 64) withArray:self.childVcs inView:self.view];
    
    self.mulChoiceView.delegate = self;
    
    [self.mulChoiceView updateScrollEnabled:YES];
    
}

-(void)selectedIndex:(NSInteger)index{
    
    [self.mulChoiceView selectIndex:index];

    NSString *type = index == 0 ? @"unread" : @"readed";

    [self messageReadedWithChatListModel:self.chatMsgListModel type:type];
    
}

- (void)scrollChangeToIndex:(NSInteger)index{
    [self.segmentTapView selectIndex:index];
    
    NSString *type = index == 2 ? @"unread" : @"readed";
    
    [self messageReadedWithChatListModel:self.chatMsgListModel type:type];
    
}

- (void)messageReadedWithChatListModel:(JGJChatMsgListModel *)chatListModel type:(NSString *)type {
      
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"msg_id"] = chatListModel.msg_id;
    parameters[@"class_type"] = chatListModel.class_type;
    parameters[@"group_id"]   = chatListModel.group_id;
    parameters[@"type"] = type;
    
    NSString *api = self.is_readed_notify ? JGJNotifyReadedMembersByMessage : JGJGroupMembersByMessage;

    [JLGHttpRequest_AFN PostWithNapi:api parameters:parameters success:^(id responseObject) {
        
        NSArray *members = responseObject[@"list"];
        
        if ([responseObject[@"type"] isEqualToString:@"readed"]) {
            
            self.read_info.readed_user_list = [ChatMsgList_Read_User_List mj_objectArrayWithKeyValuesArray:members];
            
            self.readedInfoVc.dataSourceArr = self.read_info.readed_user_list.mutableCopy;

        }else if ([responseObject[@"type"] isEqualToString:@"unread"]) {
            
            self.read_info.unread_user_list = [ChatMsgList_Read_User_List mj_objectArrayWithKeyValuesArray:members];
            
            self.unreadInfoVc.dataSourceArr = self.read_info.unread_user_list.mutableCopy;
            
        }
        
        self.segmentTapView.is_unEnable_scro = NO;

        [self MultipleChoiceTableView];
        
    } failure:^(NSError *error) {
        
        if (error.code == -1009) {
            
            [TYShowMessage showPlaint:@"网络连接不可用"];
            
        }
    }];
    
}

#pragma mark - 子类使用
- (void)subSetReadInfo:(ChatMsgList_Read_info *)readInfo {
    
    self.read_info = readInfo;
    
    [self SegmentTapView];
    
    [self MultipleChoiceTableView];
}

- (ChatMsgList_Read_info *)read_info {
    
    if (!_read_info) {
        
        _read_info = [ChatMsgList_Read_info new];
    }
    
    return _read_info;
}

@end

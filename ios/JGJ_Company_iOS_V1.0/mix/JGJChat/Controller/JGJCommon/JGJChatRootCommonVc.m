//
//  JGJChatRootCommonVc.m
//  JGJCompany
//
//  Created by Tony on 2016/12/15.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJChatRootCommonVc.h"
#import "JGJChatListCommonVc.h"
#import "JGJChatListBaseVc.h"
#import "JGJSingleChatDetailInfoVc.h"
#import "JGJGroupChatDetailInfoVc.h"
#import "JGJConversationSelectionVc.h"
@interface JGJChatRootCommonVc ()
<
JGJChatListBaseVcDelegate
>
@end

@implementation JGJChatRootCommonVc

- (void)setWorkProListModel:(JGJMyWorkCircleProListModel *)workProListModel{
    [super setWorkProListModel:workProListModel];
    
    //设置请求数据
    self.chatRootRequestModel = [JGJChatRootRequestModel new];
    
    self.chatRootRequestModel.group_id = self.workProListModel.group_id;
    
    self.chatRootRequestModel.class_type = self.workProListModel.class_type;
    
    [self MultipleChoiceTableView];
    
}

- (void )commonSet{
    [super commonSet];
    BOOL isSingleChat = [self.workProListModel.class_type isEqualToString:@"singleChat"];
     NSString *imageStr = isSingleChat ? @"icon_single_right" :  @"icon_group_right";
    if (isSingleChat) {
        self.rightItem.title = nil;
    }
    self.rightItem.image = [UIImage imageNamed:imageStr];
}

-(void)MultipleChoiceTableView{
    __weak typeof(self) weakSelf = self;
    if ([self.view.subviews containsObject:self.mulChoiceView]) {
        return;
    }
    
    self.childVcs = [[NSMutableArray alloc] init];
    
    //添加子控制器
    JGJChatListCommonVc *commonVc = [[UIStoryboard storyboardWithName:@"JGJChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJChatListCommonVc"];
    
    
    JGJChatRootChildVcModel *childVcModel = [JGJChatRootChildVcModel new];
    
    childVcModel.vc = commonVc;
    childVcModel.vcType = [self.workProListModel.class_type isEqualToString:@"singleChat"] ? JGJChatListSingleChat :JGJChatListGroupChat;
    [self.childVcs addObject:childVcModel];
    
    //配置子控制器
    [self.childVcs enumerateObjectsUsingBlock:^(JGJChatRootChildVcModel *childVcModel, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController *obj = childVcModel.vc;
        __strong typeof(weakSelf) strongSelf = weakSelf;
        obj.view.tag = idx + 1;
        
        if ([obj isKindOfClass:[JGJChatListBaseVc class]]) {
            JGJChatListBaseVc *baseVc = (JGJChatListBaseVc *)obj;
            baseVc.delegate = self;
            baseVc.workProListModel = strongSelf.workProListModel;
            baseVc.chatListRequestModel = strongSelf.chatRootRequestModel;
            baseVc.parentVc = strongSelf;
            
            //进入下一个界面
            baseVc.skipToNextVc = ^(UIViewController *nextVc){
                
                // v4.0.1 转发消息控制器 单独处理哈
                if ([nextVc isKindOfClass:[JGJConversationSelectionVc class]]) {
                    
                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:nextVc];
                    [weakSelf presentViewController:nav animated:YES completion:nil];
                    
                }else {
                    
                    [weakSelf.navigationController pushViewController:nextVc animated:YES];
                }
            };
        }
    }];
    
    
    CGFloat mulChoiceY = 0;
    self.mulChoiceView = [[MultipleChoiceTableView alloc] initWithFrame:CGRectMake(0, mulChoiceY, TYGetUIScreenWidth, TYGetUIScreenHeight - mulChoiceY - 64) withArray:[self getChildVcs] inView:self.view];
    self.mulChoiceView.delegate = self;
}

#pragma mark - 进入聊天的通用界面
- (IBAction)skipToCommonChatVc:(id)sender {
    
    if ([self.workProListModel.class_type isEqualToString:@"singleChat"]) {
        JGJSingleChatDetailInfoVc *singleChatDetailInfoVc  = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJSingleChatDetailInfoVc"];
        singleChatDetailInfoVc.workProListModel = self.workProListModel;
        [self.navigationController pushViewController:singleChatDetailInfoVc animated:YES];
    }else if ([self.workProListModel.class_type isEqualToString:@"groupChat"]) {
        JGJGroupChatDetailInfoVc *groupChatDetailInfoVc  = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatDetailInfoVc"];
        groupChatDetailInfoVc.workProListModel = self.workProListModel;
        [self.navigationController pushViewController:groupChatDetailInfoVc animated:YES];
    }else {
        
        UIViewController *mangerVC = [[UIStoryboard storyboardWithName:@"JGJTeamManger" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupMangerVC"];
        [mangerVC setValue:self.workProListModel forKey:@"workProListModel"];
        [self.navigationController pushViewController:mangerVC animated:YES];
    }
}
@end


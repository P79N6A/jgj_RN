//
//  JGJAddFriendSendMsgVc.m
//  mix
//
//  Created by YJ on 17/2/13.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJAddFriendSendMsgVc.h"
#import "JGJAddFriendSendMsgCell.h"
#import "JGJAddFriendSendMsgRemarkCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "NSString+Extend.h"
#import "JGJYJLable.h"

#import "JGJConRecomVc.h"
#import "JGJDataManager.h"


@interface JGJAddFriendSendMsgVc ()
<
UITableViewDelegate,
UITableViewDataSource,
JGJAddFriendSendMsgCellDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *inputMsg;
@property (nonatomic, strong) NSArray *remarks;
@property (nonatomic, strong) NSIndexPath *lastIndexPath;
@property (nonatomic, strong) JGJAddFriendSendMsgModel *sendMsgModel;
@end

@implementation JGJAddFriendSendMsgVc

@synthesize remarks = _remarks;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJAddFriendSendMsgCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"JGJAddFriendSendMsgCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"JGJAddFriendSendMsgRemarkCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"JGJAddFriendSendMsgRemarkCell"];
    [self loadMessageList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 1;
    if (section == 1) {
        count = self.remarks.count;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0.0;
    JGJAddFriendSendMsgModel *sendMsgModel = self.remarks[indexPath.row];
    if (indexPath.section == 0) {
        height = 86.0;
        
    }else if (indexPath.section == 1) {
        height = [tableView  fd_heightForCellWithIdentifier:@"JGJAddFriendSendMsgRemarkCell" configuration:^(JGJAddFriendSendMsgRemarkCell *cell) {
            cell.sendMsgModel = sendMsgModel;
        }];
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    NSString *myName = [TYUserDefaults objectForKey:JGJUserName];
    if (indexPath.section == 0) {
        JGJAddFriendSendMsgCell *sendMsgCell = [tableView dequeueReusableCellWithIdentifier:@"JGJAddFriendSendMsgCell" forIndexPath:indexPath];
        sendMsgCell.delegate = self;
        NSString *oriInfoMsg = [NSString stringWithFormat:@"我是%@", myName];
        NSString *inputMsgStr = @"";
        if ([self.inputMsg rangeOfString:oriInfoMsg].location != NSNotFound) {
            
            inputMsgStr = self.inputMsg;
            
        }else {
        
            inputMsgStr = [NSString stringWithFormat:@"%@%@", oriInfoMsg, self.inputMsg?:@""];
        }
        
        sendMsgCell.inputMsg = inputMsgStr;
        cell = sendMsgCell;
    }else if (indexPath.section == 1) {
        JGJAddFriendSendMsgRemarkCell *sendMsgCell = [tableView dequeueReusableCellWithIdentifier:@"JGJAddFriendSendMsgRemarkCell" forIndexPath:indexPath];
        sendMsgCell.sendMsgModel = self.remarks[indexPath.row];
        sendMsgCell.lineView.hidden = self.remarks.count - 1 == indexPath.row;
        cell = sendMsgCell;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return;
    }
    [self JGJTableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)JGJTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *temp = self.lastIndexPath;
    if(temp && temp != indexPath) {
        JGJAddFriendSendMsgModel *lastSendMsgModel = self.remarks[self.lastIndexPath.row];
        lastSendMsgModel.isSelected = NO;//修改之前选中的cell的数据为不选中
        [tableView reloadRowsAtIndexPaths:@[temp] withRowAnimation:UITableViewRowAnimationNone];
    }
    //选中的修改为当前行
    JGJAddFriendSendMsgModel *sendMsgModel = self.remarks[indexPath.row];
    self.lastIndexPath = indexPath;
    sendMsgModel.isSelected = YES;
    if (sendMsgModel.isSelected) {
        self.sendMsgModel = sendMsgModel;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)setSendMsgModel:(JGJAddFriendSendMsgModel *)sendMsgModel {
    _sendMsgModel = sendMsgModel;
    if (![sendMsgModel.msg_text isEqualToString:@"无"]) {
        self.inputMsg = [NSString stringWithFormat:@"%@%@", sendMsgModel.msg_text?@"，":@"", sendMsgModel.msg_text];
    }else {
        self.inputMsg = @"";
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)textViewCell:(JGJAddFriendSendMsgCell *)cell didChangeText:(NSString *)inputText
{
    self.inputMsg = inputText;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height = 30.0;
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = AppFontf1f1f1Color;
    JGJYJLable *headerTitle = [[JGJYJLable alloc] init];
    headerTitle.backgroundColor = [UIColor clearColor];
    headerTitle.font = [UIFont systemFontOfSize:AppFont24Size];
    CGFloat padding = 12.0;
    headerTitle.textColor = AppFont999999Color;
    [headerView addSubview:headerTitle];
    if (section == 0) {
        headerTitle.text = @"添加朋友需要发送验证申请，等待对方同意";
    }else if (section == 1) {
        headerTitle.numberOfLines = 0;
        [headerTitle setVerticalAlignment:VerticalAlignmentBottom];
        height = 50.0;
        headerTitle.text = @"你还可以选择以下常用申请模板：\n";
    }
    headerTitle.frame = CGRectMake(padding, 0, TYGetUIScreenWidth - padding, height);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 30.0;
    if (section == 1) {
        height = 50.0;
    }
    return height;
}

- (IBAction)handleRightItemPressed:(UIBarButtonItem *)sender {
    self.inputMsg = [self.inputMsg stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除掉首尾的空白字符和换行字符
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"msg_text"] = (self.inputMsg ?: @"");
    parameters[@"uid"] = (self.perInfoModel.uid ?: @"");
   
    if ([JGJDataManager sharedManager].addFromType) {
        parameters[@"add_from"] = @([JGJDataManager sharedManager].addFromType);
    }
    __weak typeof(self) weakSelf = self;
    
    [TYLoadingHub showLoadingWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/add-friends" parameters:parameters success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        [TYShowMessage showSuccess:@"已发送"];
        
        [weakSelf sendSuccessWithResult:responseObject];
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)sendSuccessWithResult:(id)result {
    
    for (JGJConRecomVc *comVc in self.navigationController.viewControllers) {
        
        if ([comVc isKindOfClass:NSClassFromString(@"JGJConRecomVc")]) {
            
            if (comVc.sendSuccessBlock) {
                
               comVc.sendSuccessBlock(result);
            }
            
            break;
        }
    }
    
}

#pragma mark - 加载消息列表
- (void)loadMessageList {
    
    __weak typeof(self) weakSelf = self;
    
    [JLGHttpRequest_AFN PostWithNapi:@"chat/get-message-tpl-list" parameters:nil success:^(id responseObject) {
        
        [TYLoadingHub hideLoadingView];
        
        weakSelf.remarks = [JGJAddFriendSendMsgModel mj_objectArrayWithKeyValuesArray:responseObject];
        
    } failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
        
    }];
    
}

- (void)setRemarks:(NSArray *)remarks {
    _remarks = remarks;
    if (_remarks.count > 0) {
        JGJAddFriendSendMsgModel *sendMsgModel = _remarks[0];
        sendMsgModel.isSelected = YES;
        self.lastIndexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView reloadData];
        self.sendMsgModel = sendMsgModel;
    }
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];

}

@end

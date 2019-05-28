//
//  JGJLaunchGroupChatVc.m
//  mix
//
//  Created by yj on 16/12/22.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJLaunchGroupChatVc.h"
#import "JGJGroupChatListVc.h"
#import "JGJGetViewFrame.h"
#import "JGJFaceGrounpViewController.h"
#import "JGJImageModelView.h"
typedef enum : NSUInteger {
    JGJSelectedExistedCreatGroupType,
    JGJSelectedFacetoFaceCreatGroupType,
    JGJSelectedWorkCircleCreatGroupType
} JGJSelectedCreatGroupType;
typedef void(^HandleGroupChatListVcBlock)(NSArray *);
@interface JGJLaunchGroupChatVc ()<ClickPeopleItemButtondelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentSelectedMemberView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentSelectedMemberViewH;
@property (weak, nonatomic) IBOutlet UIButton *joinGroupChatButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentJoinGroupChatButtonViewH;

@property (weak, nonatomic) IBOutlet UIView *contentJoinGroupChatButtonView;
@property (strong, nonatomic) NSMutableArray *headCellInfoModels;
@property (strong, nonatomic) NSMutableArray *selectedMembers;
@property (strong, nonatomic) JGJImageModelView *imageModelView;
/**
 *  回调是否请求有数据
 */
@property (nonatomic, copy) HandleGroupChatListVcBlock handleGroupChatListVcBlock;
@end

@implementation JGJLaunchGroupChatVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起群聊";
    [self.contentSelectedMemberView addSubview:self.imageModelView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.joinGroupChatButton.layer setLayerCornerRadius:JGJCornerRadius];
    [self showBottomGroupChatButton];
}

- (void)JGJAddressBookTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SortFindResultModel *sortFindResult = self.sortContactsModel.sortContacts[indexPath.section - 1];
    JGJSynBillingModel *contactModel = sortFindResult.findResult[indexPath.row];
    contactModel.indexPathMember = indexPath;
    contactModel.isSelected = !contactModel.isSelected;
    if (contactModel.isSelected) {
        [self.selectedMembers addObject:contactModel];
    }else {
        [self.selectedMembers removeObject:contactModel];
    }
    
    [self showBottomGroupChatButton];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)JGJAddressBookHeadCellWithTableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JGJSelectedCreatGroupType creatGroupType = indexPath.row;
    switch (creatGroupType) {
        case JGJSelectedExistedCreatGroupType: {
            
            [self handleSelectedExistedCreatGroup];
            
        }
            break;
        case JGJSelectedFacetoFaceCreatGroupType:
            [self handleSelectedFacetoFaceCreatGroup];
            break;
        case JGJSelectedWorkCircleCreatGroupType: {
            
//            [self loadGroupChatList:JGJGroupChatListWorkVcType];
            
             [self handleSelectedWorkCircleCreatGroup];
            
//            __weak typeof(self) weakself = self;
//            self.handleGroupChatListVcBlock = ^(NSArray *groupChatList){
//                if (groupChatList.count > 0) {
//                    [weakself handleSelectedWorkCircleCreatGroup];
//                }else {
//                    [TYShowMessage showError:@"你暂时没有加入任何项目"];
//                }
//            };
        }
            break;
        default:
            break;
    }
}

#pragma amrk - 点击效果
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = cell.highlighted ? AppFontE6E6E6Color : [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - 处理选择现有群
- (void)handleSelectedExistedCreatGroup {
    JGJGroupChatListVc *groupChatListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatListVc"];
    groupChatListVc.groupChatListVcType = JGJGroupChatListDefaultVcType;
    groupChatListVc.chatType = JGJSingleChatType;
    [self.navigationController pushViewController:groupChatListVc animated:YES];
}

#pragma mark - 处理面对面建群
- (void)handleSelectedFacetoFaceCreatGroup {
    JGJFaceGrounpViewController *viewControl = [[JGJFaceGrounpViewController alloc]init];
    viewControl.navigationItem.title = @"面对面建群";

    [self.navigationController pushViewController:viewControl animated:YES];

}

#pragma mark - ClickPeopleItemButtondelegate
- (void)ClickPeopleItem:(NSMutableArray *)ModelArray anIndexpath:(NSIndexPath *)indexpath deleteObeject:(JGJSynBillingModel *)deleteModel {
    deleteModel.isSelected = NO;
    if (self.selectedMembers.count > 0) {
        [self.selectedMembers removeObject:deleteModel];
    }
    [self.tableView reloadRowsAtIndexPaths:@[deleteModel.indexPathMember] withRowAnimation:UITableViewRowAnimationNone];
    self.selectedMembers = ModelArray;
    [self showBottomGroupChatButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
#pragma mark - 处理工项目建群
- (void)handleSelectedWorkCircleCreatGroup {
    JGJGroupChatListVc *groupChatListVc = [[UIStoryboard storyboardWithName:@"JGJContacted" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJGroupChatListVc"];
    groupChatListVc.groupChatListVcType = JGJGroupChatListWorkVcType;
    groupChatListVc.contactedAddressBookVcType = JGJLaunchGroupChatVcType; //发起群聊
    groupChatListVc.chatType = JGJGroupChatType;
    [self.navigationController pushViewController:groupChatListVc animated:YES];
}

- (IBAction)handleGroupChatButtonAction:(UIButton *)sender {
    [super handleCreatGroupChatRequest];
}

#pragma mark - otherMethod
- (void)showBottomGroupChatButton {
    self.imageModelView.DataMutableArray = self.selectedMembers;
    self.joinGroupChatButton.enabled = NO;
    self.joinGroupChatButton.backgroundColor = TYColorHex(0xaaaaaa);
    self.contentSelectedMemberViewH.constant = 0;
    self.contentSelectedMemberView.hidden = YES;;
//    self.contentJoinGroupChatButtonViewH.constant = 0;
//    self.contentJoinGroupChatButtonView.hidden = YES;
    if (self.selectedMembers.count > 0) {
//        self.contentJoinGroupChatButtonViewH.constant = 63;
//        self.contentJoinGroupChatButtonView.hidden = NO;
        self.joinGroupChatButton.backgroundColor = AppFontd7252cColor;
        self.joinGroupChatButton.enabled = YES;
        self.contentSelectedMemberViewH.constant = 48;
        self.contentSelectedMemberView.hidden = NO;
        NSString *buttonTitle = [NSString stringWithFormat:@"进入群聊 (%@)", @(self.selectedMembers.count)];
        [self.joinGroupChatButton setTitle:buttonTitle forState:UIControlStateNormal];
    }else {
//        self.contentJoinGroupChatButtonViewH.constant = 0;
//        self.contentJoinGroupChatButtonView.hidden = YES;
        self.contentSelectedMemberViewH.constant = 0;
        self.contentSelectedMemberView.hidden = YES;
        [self.joinGroupChatButton setTitle:@"进入群聊" forState:UIControlStateNormal];
    }
}

#pragma mark - getter
- (NSMutableArray *)headCellInfoModels {
    NSArray *titles = @[@"选择现有群",@"面对面建群",@"从项目建群"];
    if (!_headCellInfoModels) {
        _headCellInfoModels = [NSMutableArray array];
        for (int indx = 0; indx < titles.count; indx++) {
            JGJCreatTeamModel *teamModel = [[JGJCreatTeamModel alloc] init];
            teamModel.title = titles[indx];
            teamModel.placeholderTitle = @"";
            [_headCellInfoModels addObject:teamModel];
        }
    }
    return _headCellInfoModels;
}

- (NSMutableArray *)selectedMembers {
    if (!_selectedMembers) {
        _selectedMembers = [NSMutableArray array];
    }
    return _selectedMembers;
}

- (JGJImageModelView *)imageModelView {
    
    if (!_imageModelView) {
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, 48.0);
        _imageModelView = [[JGJImageModelView alloc] initWithFrame:rect];
        _imageModelView.peopledelegate = self;
    }
    return _imageModelView;
}

@end

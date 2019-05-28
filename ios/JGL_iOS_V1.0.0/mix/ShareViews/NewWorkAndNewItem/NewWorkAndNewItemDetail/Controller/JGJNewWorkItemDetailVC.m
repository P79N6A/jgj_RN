//
//  JGJNewWorkItemVC.m
//  mix
//
//  Created by celion on 16/4/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNewWorkItemDetailVC.h"
#import "JLGProMapViewController.h"
#import "JGJReportViewController.h"
#import "JGJShowContactsVC.h"
#import "TYPhone.h"

#import "SDWebImageManager.h"
#import "JGJCustomListView.h"
#import "AppDelegate+JLGThirdLib.h"
#import "JGJEditProExperienceVC.h"
#import "JGJDetailCallView.h"
#import "JLGFHLeaderDetailModel.h"
#import "TYShowMessage.h"

@interface JGJNewWorkItemDetailVC ()
@property (weak, nonatomic) IBOutlet UIButton *showSkillButton;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (strong, nonatomic) UIImage *shareImage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *callButtonWidth;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@end

@implementation JGJNewWorkItemDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonset];
    [self loadNetData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    count = self.jlgFindProjectModel.welfare.count == 0 ? 5 : 6;
    if (self.jlgFindProjectModel.findresult.count == 0) {
        count --;
    }
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    CGFloat contactHeight = TYIS_IPHONE_5 || TYIS_IPHONE_4_OR_LESS ? 144 : (TYIS_IPHONE_6P ? 174 : 154);
    
    NSArray *heights = @[@77,  @121,  @20, @134,  @86 ,  @(contactHeight)];
    NSArray *otherHeights = @[@77,  @121,  @134,  @86 ,  @(contactHeight)];
    if (self.jlgFindProjectModel.welfare.count == 0) {
        height = [otherHeights[indexPath.row] doubleValue];
            if (indexPath.row == 2) {
                 height = [self.publishCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
        } else {
        height = [heights[indexPath.row] doubleValue];
            if (indexPath.row == 2) {
                height = 25 + self.jlgFindProjectModel.welfareHeight;
            }
            if (indexPath.row == 3) {
                height = [self.publishCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
            }
    }
    if (indexPath.row == 0) {
        height = 77 + self.jlgFindProjectModel.strViewH;
    }
    
    if (indexPath.row == 1) {
        height = [self.timelimitCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    return height ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (self.jlgFindProjectModel.welfare.count == 0) {
        switch (indexPath.row) {
            case TopCellType:
                cell = [self getTopCell:tableView indexPath:indexPath];
                break;
            case TimelimitCellType:
                cell = [self getTimelimitCell:tableView indexPath:indexPath];
                break;
            case 2:
                cell = [self getPublshCell:tableView indexPath:indexPath];
                break;
            case 3:
                cell = [self getReportCell:tableView indexPath:indexPath];
                break;
            case 4:
                cell = [self getContactsCell:tableView indexPath:indexPath];
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case TopCellType:
                cell = [self getTopCell:tableView indexPath:indexPath];
                break;
            case TimelimitCellType:
                cell = [self getTimelimitCell:tableView indexPath:indexPath];
                break;
            case BenefitCellType:
                cell = [self getBenefitCell:tableView indexPath:indexPath];
                break;
            case PublshCellType:
                cell = [self getPublshCell:tableView indexPath:indexPath];
                break;
            case ReportCellType:
                cell = [self getReportCell:tableView indexPath:indexPath];
                break;
            case ContactsCellType:
                cell = [self getContactsCell:tableView indexPath:indexPath];
                break;
            default:
                break;
        }
    }
       return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark - 配置cell
- (JGJNewWorkDetailTopCell *)getTopCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    JGJNewWorkDetailTopCell *topCell = [tableView dequeueReusableCellWithIdentifier:@"JGJNewWorkDetailTopCell" forIndexPath:indexPath];
    topCell.jlgFindProjectModel = self.jlgFindProjectModel;
    return topCell;
}

- (JGJNewWorkDetailTimelimitCell *)getTimelimitCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    self.timelimitCell.jlgFindProjectModel = self.jlgFindProjectModel;
    return self.timelimitCell;
}

- (JGJNewWorkDetailPublshCell *)getPublshCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
//    JGJNewWorkDetailPublshCell *publishCell = [tableView dequeueReusableCellWithIdentifier:@"JGJNewWorkDetailPublshCell" forIndexPath:indexPath ];
    self.publishCell.jlgFindProjectModel = self.jlgFindProjectModel;
    self.publishCell.blockCheckMapButtonPressed = ^{
        JLGProMapViewController *proMapVc = [[UIStoryboard storyboardWithName:@"FindJob" bundle:nil] instantiateViewControllerWithIdentifier:@"proMap"];
        proMapVc.proname = weakSelf.jlgFindProjectModel.proname;
        proMapVc.proaddress = weakSelf.jlgFindProjectModel.proaddress;
        proMapVc.prolocation = weakSelf.jlgFindProjectModel.prolocation;
        [weakSelf.navigationController pushViewController:proMapVc animated:YES];
    };
    return self.publishCell;
}

- (JGJNewWorkDetailReportCell *)getReportCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    JGJNewWorkDetailReportCell *reportCell = [tableView dequeueReusableCellWithIdentifier:@"JGJNewWorkDetailReportCell" forIndexPath:indexPath];
    reportCell.jlgFindProjectModel = self.jlgFindProjectModel;
    reportCell.blockReportButtonDidClickedPressed = ^{
        JGJReportViewController *reportViewController = [[UIStoryboard storyboardWithName:@"FindProject" bundle:nil] instantiateViewControllerWithIdentifier:@"reportVc"];
        reportViewController.pid = [NSString stringWithFormat:@"%ld", (long)self.jlgFindProjectModel.pid];
        [weakSelf.navigationController pushViewController:reportViewController animated:YES];
    };
    return reportCell;
}

- (JLGFindJobDetailContactsTableViewCell *)getContactsCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    JLGFindJobDetailContactsTableViewCell *contactscell = [JLGFindJobDetailContactsTableViewCell cellWithTableView:tableView];
    contactscell.friendsInfoArray = [self.jlgFindProjectModel.findresult copy];
    contactscell.blockContactButtonPressed = ^ {
        UIStoryboard *contactsStoryboard = [UIStoryboard storyboardWithName:@"JGJContacts" bundle:nil] ;
        JGJShowContactsVC *contactsVC = [contactsStoryboard instantiateViewControllerWithIdentifier:@"JGJShowContactsVC"];
        JLGFHLeaderDetailModel *jlgFHLeaderDetailModel = [[JLGFHLeaderDetailModel alloc] init];
        jlgFHLeaderDetailModel.findresult = weakSelf.jlgFindProjectModel.findresult;
        contactsVC.jlgFHLeaderDetailModel = jlgFHLeaderDetailModel;
        [weakSelf.navigationController pushViewController:contactsVC animated:YES];
    };
    return contactscell;
}

- (JGJNewWorkDetailBenefitCell *)getBenefitCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    JGJNewWorkDetailBenefitCell *benefitCell = [tableView dequeueReusableCellWithIdentifier:@"JGJNewWorkDetailBenefitCell" forIndexPath:indexPath];
    benefitCell.jlgFindProjectModel = self.jlgFindProjectModel;
    return benefitCell;
}


- (IBAction)didClickedButtonPressed:(UIButton *)sender {
    if (sender.tag == 101) {
        SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
        if (![self.navigationController performSelector:checkIsLogin]) {
            return ;
        }
        
        SEL checkIsInfo = NSSelectorFromString(@"checkIsInfo");
        if (![self.navigationController performSelector:checkIsInfo]) {
            return ;
        }

        if (self.jlgFindProjectModel.contact_info.count > 1) {
            
            CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight);
            JGJDetailCallView *detailCallView = [[JGJDetailCallView alloc] initWithFrame:rect findProjectModel:self.jlgFindProjectModel];
            __weak typeof(self) weakSelf = self;
            detailCallView.blockContactInfo = ^(FindResultModel *finResultModel){
                
                [weakSelf callButtonClickedPressed:finResultModel.telph];
            };
            [[[UIApplication sharedApplication] delegate].window addSubview:detailCallView];
        } else {

            FindResultModel *findResultModel = self.jlgFindProjectModel.contact_info[0];
            [self callButtonClickedPressed:findResultModel.telph];
        }
    }
    
    if (sender.tag == 100) {

        UIViewController *editProExper = [[UIStoryboard storyboardWithName:@"MateMine" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJEditProExperienceVC"];
        [editProExper setValue:@(YES) forKey:@"isBackLevel"];
        [editProExper setValue:[NSString stringWithFormat:@"%@",@(self.jlgFindProjectModel.pid)] forKey:@"pid"];
        [self.navigationController pushViewController:editProExper animated:YES];
    }
}

- (void)callButtonClickedPressed:(NSString *)telephone {

    [TYPhone callPhoneByNum:telephone view:self.view];
//    Classes *classes = [self.jlgFindProjectModel.classes firstObject]; 2.1.2-yj和找工作交互删除
    Classes *classes = [Classes new];
    
    NSInteger worktype = classes.worktype.code;
    NSDictionary *parameters = @{@"pid":@(self.jlgFindProjectModel.pid) ?:[NSNull null],
                                 @"worktype" : @(worktype) ?: [NSNull null]
                                 };
    [JLGHttpRequest_AFN PostWithApi:@"jlforemanwork/tocontactbysnapshot" parameters:parameters success:^(NSDictionary * responseObject) {
    }failure:^(NSError *error) {

    }];
}

//分享代码注释
- (IBAction)shareButtonPressed:(UIButton *)sender {
//    {
//        NSString *shareText = [NSString stringWithFormat:@"%@ \n%@ \n%@",self.jlgFindProjectModel.share[@"wxshare_title"],self.jlgFindProjectModel.share[@"wxshare_desc"],self.jlgFindProjectModel.share[@"wxshare_uri"]];
//
//        //调用快速分享接口
//        [UMSocialSnsService presentSnsIconSheetView:self
//                                             appKey:UmengApp_KEY
//                                          shareText:shareText
//                                         shareImage:self.shareImage
//                                    shareToSnsNames:nil
//                                           delegate:self];
//
//        //微信
//        [UMSocialData defaultData].extConfig.wechatSessionData.url = self.jlgFindProjectModel.share[@"wxshare_uri"];
//
//        //朋友圈
//        [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.jlgFindProjectModel.share[@"wxshare_uri"];
//
//        //QQ
//        [UMSocialData defaultData].extConfig.qqData.url = self.jlgFindProjectModel.share[@"wxshare_uri"];
//
//        //分享到Qzone内容
//        [UMSocialData defaultData].extConfig.qzoneData.url = self.jlgFindProjectModel.share[@"wxshare_uri"];
//    }
    
}

- (void)getShareImages{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    //分享的图片
    NSURL *shareImageURL = [NSURL URLWithString:self.jlgFindProjectModel.share[@"wxshare_img"]];
    
    [manager downloadImageWithURL:shareImageURL
                          options:0
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if (image) {
                                self.shareImage = image;
                            }else{
                                self.shareImage = [UIImage imageNamed:@"Logo"];
                            }
                        }];
}

- (void)loadNetData {
    [TYLoadingHub showLoadingWithMessage:nil];
    //    Classes *classes = [self.jlgFindProjectModel.classes firstObject]; 2.1.2-yj和找工作交互删除
    Classes *classes = [Classes new];
    NSInteger worktype = classes.worktype.code;
    NSDictionary *para = @{  @"pid":@(self.jlgFindProjectModel.pid) ?:[NSNull null],
                             @"work_type":@(worktype),
                             @"contacted":@(self.isShowSkill)
                           };
    [JLGHttpRequest_AFN PostWithApi:@"jlwork/prodetailactive" parameters:para success:^(NSDictionary * responseObject) {
        [TYLoadingHub hideLoadingView];
        
        self.jlgFindProjectModel = [JLGFindProjectModel mj_objectWithKeyValues:responseObject];
        if (self.jlgFindProjectModel == nil) {
            [TYShowMessage showError:@"没有数据"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        self.jlgFindProjectModel.maxWidth = TYGetUIScreenWidth;
        self.jlgFindProjectModel.welfareMaxWidth = TYGetUIScreenWidth - 85;
        JGJCustomListView *cuslistView = [[JGJCustomListView alloc] init];
        [cuslistView setCustomListViewDataSource:self.jlgFindProjectModel.welfare lineMaxWidth:TYGetUIScreenWidth - 85];
        self.jlgFindProjectModel.welfareHeight = cuslistView.totalHeight;
        self.tableView.hidden = NO;
        
        [self RefreshBottomView];
        [self.tableView reloadData];
    }failure:^(NSError *error) {
         [TYLoadingHub hideLoadingView];
    }];
}

- (void)commonset {
    self.timelimitCell = [self.tableView dequeueReusableCellWithIdentifier:@"JGJNewWorkDetailTimelimitCell"];
    self.publishCell = [self.tableView dequeueReusableCellWithIdentifier:@"JGJNewWorkDetailPublshCell"];
    if (!self.isShowSkill) {
        self.callButtonWidth.constant = TYGetUIScreenWidth - 20;
        self.showSkillButton.hidden = YES;
    }
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    self.tableView.hidden = YES;
    [self.showSkillButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
    [self.callButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
    self.bottomView.backgroundColor = AppFontfafafaColor;
    //在bottomView上面增加一条分割线
    UIView *bottomViewTopLineView = [[UIView alloc] init];
    bottomViewTopLineView.backgroundColor = AppFontccccccColor;
    [self.bottomView addSubview:bottomViewTopLineView];
    [bottomViewTopLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView);
        make.right.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView);
        make.height.equalTo(@0.5);
    }];
    
    [self getShareImages];//获取分享的图片
}

- (void)RefreshBottomView{

}

@end

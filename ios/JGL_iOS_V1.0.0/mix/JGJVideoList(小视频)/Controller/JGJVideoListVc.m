//
//  JGJVideoListVc.m
//  mix
//
//  Created by yj on 2018/3/23.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJVideoListVc.h"

#import "ZFPlayer.h"

#import "JGJVideoListRequestModel.h"

#import "JGJKnowledgeDaseTool.h"

#import "JLGCustomViewController.h"

#import "MJRefresh.h"
#import "UITableView+Video.h"

#import "UITableView+JGJLoadCategory.h"

#define JGJPageSize 10

@interface JGJVideoListVc () <UITableViewDelegate, UITableViewDataSource, ZFPlayerDelegate, JGJVideoListCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *videoList;

@property (nonatomic, strong) ZFPlayerView        *playerView;

@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) JGJVideoListRequestModel *request;

//重置视频
@property (nonatomic, assign) BOOL resetPlay;

//分享菜单
@property (nonatomic, strong) JGJKnowledgeDaseTool *shareMenuTool;

@property (nonatomic, strong) JGJVideoListModel *selListModel;

//正在播放的Cell
@property (nonatomic, strong) JGJVideoListCell *playingCell;

@property (nonatomic,assign) CGFloat lastOffsetY;

@property (nonatomic,strong) UIView *centerSepLine;

//是否加载完毕
@property (nonatomic, assign) BOOL isLoadFinish;

@property (nonatomic, strong) JGJFooterViewInfoModel *footerInfoModel;

@end

@implementation JGJVideoListVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 400.0f;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.view addSubview:self.tableView];
    
//    [self.view addSubview:self.centerSepLine];
    
    self.tableView.mj_header = [MJRefreshStateHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadVideoList)];

    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreVideoList)];

//    [self loadVideoList];
    
    self.title = @"精彩小视频";
    
    [self.tableView.mj_header beginRefreshing];

    [self commonSet];
}

#pragma mark - 常用设置
- (void)commonSet {
    
    // 控制器默认背景颜色
    self.view.backgroundColor = [UIColor blackColor];
    
    // 设置返回按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(0, 0, 70, JGJLeftButtonHeight);
    
    // 让按钮的内容往左边偏移5
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    
    [btn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    
    [btn setImage:[UIImage imageNamed:@"barButtonItem_back_white"] forState:UIControlStateNormal];
    
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor blackColor]] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:JGJNavBarFont],
       
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];//设置颜色
    
}

/**
 将UIColor转换成图片
 */
- (UIImage*)createImageWithColor:(UIColor*)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

// 页面消失时候
- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self.playerView resetPlayer];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:JGJNavBarFont],
       
       NSForegroundColorAttributeName:AppFont333333Color}];
    
    [self.navigationController.navigationBar setBackgroundImage:[self createImageWithColor:AppFontfafafaColor] forBarMetrics:UIBarMetricsDefault];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.videoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJVideoListCell *cell = [JGJVideoListCell cellWithTableView:tableView];
    
    JGJVideoListModel *listModel = self.videoList[indexPath.row];
        
    cell.delegate = self;
    
    cell.listModel = listModel;
    
    __weak JGJVideoListCell *weakCell = cell;
    
    TYWeakSelf(self);
    
    cell.playBlock = ^(UIButton *sender, JGJVideoListModel *listModel) {

        [weakself playActionWithCell:weakCell indexPath:indexPath];
        
        
    };
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return _isLoadFinish ? JGJFooterHeight : CGFLOAT_MIN;;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footerView = [self.tableView setFooterViewInfoModel:self.footerInfoModel];
    
    return _isLoadFinish ? footerView : nil;
    
}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//
//    TYLog(@"scrollViewDidEndDecelerating---------------1111");
//
//    [self.tableView handleScrollPlay];
//
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    TYLog(@"scrollViewDidScroll---------------222");
//    CGFloat offsetY = scrollView.contentOffset.y;
//
//    CGFloat delaY = offsetY - self.lastOffsetY;
//
//    self.tableView.scrollDirection = delaY > 0 ? LC_SCROLL_UP : LC_SCROLL_DOWN;
//
//    if (delaY == 0) {
//        self.tableView.scrollDirection = LC_SCROLL_NONE;
//    }
//
//    self.lastOffsetY = offsetY;
//
//
//    //判断快速滑动期间是否移动到屏幕外
//    [self.tableView handleScrollingCellOutScreen];
//
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//
//    TYLog(@"willDecelerate:(BOOL)decelerate---------------222  %@", @(decelerate));
//
//    if (!decelerate) {
//
//        [self.tableView handleScrollPlay];
//
//    }
//
//}

- (void)playActionWithCell:(JGJVideoListCell *)cell indexPath:(NSIndexPath *)indexPath {

//    // 分辨率字典（key:分辨率名称，value：分辨率url)
//    NSMutableDictionary *dic = @{}.mutableCopy;
//    for (ZFVideoResolution * resolution in model.playInfo) {
//        [dic setValue:resolution.url forKey:resolution.name];
//    }
    // 取出视频URL
    NSURL *videoURL = [NSURL URLWithString:cell.listModel.video_url];

    ZFPlayerModel *playerModel = [[ZFPlayerModel alloc] init];
    
    playerModel.title            = cell.listModel.title?:@"";
    
    playerModel.videoURL         = videoURL;

    if (cell.listModel.pic_src.count > 0) {

        playerModel.placeholderImageURLString = cell.listModel.pic_src.firstObject;
    }

    playerModel.scrollView       = self.tableView;
    
    playerModel.indexPath        = indexPath;
    // 赋值分辨率字典
//    playerModel.resolutionDic    = dic;
    // player的父视图tag
    playerModel.fatherViewTag    = cell.coverImageView.tag;

    playerModel.fatherView = cell.coverImageView;
    
    // 设置播放控制层和model
    [self.playerView playerControlView:self.controlView playerModel:playerModel];
    // 下载功能
    self.playerView.hasDownload = NO;
    // 自动播放
    [self.playerView autoPlayTheVideo];
    
    cell.coverBottomView.alpha = 0;
    
    cell.coverVideoView.alpha = 0;
    
}

- (UIView *)centerSepLine{
    
    if (!_centerSepLine) {
        _centerSepLine = [UIView new];
        _centerSepLine.backgroundColor = [UIColor orangeColor];
        _centerSepLine.frame = CGRectMake(0,(TYGetUIScreenHeight - JGJ_NAV_HEIGHT) * 0.5, self.view.frame.size.width, 1);
    }
    
    return _centerSepLine;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        CGRect rect = CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - JGJ_NAV_HEIGHT);
        
        _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.dataSource = self;
        
        _tableView.delegate = self;
        
        _tableView.backgroundColor = [UIColor blackColor];
        
        self.view.backgroundColor = AppFontf1f1f1Color;

    }
    
    return _tableView;
    
}

#pragma mark - JGJVideoListCellDelagate

- (void)videoListCell:(JGJVideoListCell *)cell buttonType:(JGJVideoListCellButtonType)buttonType {
//    JGJVideoListCellButtonComType,
//
//    JGJVideoListCellButtonPraiseType,
//
//    JGJVideoListCellButtonShareType
    switch (buttonType) {
            
        case JGJVideoListCellButtonComType:{
            
            [self handleButtonActionWithListModel:cell.listModel buttonType:JGJVideoListCellButtonComType];
        }
            
            
            break;
            
        case JGJVideoListCellButtonPraiseType:{
            
            [self commentPraiseWithCell:cell];
        }
            
            
            break;
            
        case JGJVideoListCellButtonShareType:{
         
            [self shareWithListModel:cell.listModel];
            
        }
            break;
            
        case JGJVideoListCellButtonNameHeadType:{
            
            [self handleButtonActionWithListModel:cell.listModel buttonType:JGJVideoListCellButtonNameHeadType];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 评论 点击头像

- (void)handleButtonActionWithListModel:(JGJVideoListModel *)listModel buttonType:(JGJVideoListCellButtonType)buttonType {
    
    switch (buttonType) {
            
        case JGJVideoListCellButtonNameHeadType:{
            
            if (self.responseCallback) {
                
                self.responseCallback(@{@"uid" : listModel.user_info.uid?:@""});
            }
        }
            
            break;
            
        case JGJVideoListCellButtonComType:{
            
            if (self.responseCallback) {
                
                self.responseCallback(@{@"id" : listModel.post_id?:@""});
            }
        }
            
            break;
            
        default:
            break;
    }
    
    [self.navigationController popViewControllerAnimated:NO];
    
}

#pragma mark - 评论点赞
- (void)commentPraiseWithCell:(JGJVideoListCell *)cell {
    
    //    comment_id
    //    1点赞，2取消点赞
    NSString *type = [cell.listModel.is_liked isEqualToString:@"1"] ? @"2" : @"1";
    
//    class_type    是    int    1,帖子点赞，2评论点赞
    
    NSDictionary *parameters = @{@"id" : cell.listModel.post_id?:@"",
                                 @"type" : type,
                                 @"class_type" : @"1"
                                 };
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/dynamic/dynamicLiked" parameters:parameters success:^(id responseObject) {
        
        JGJVideoListModel *listModel = [JGJVideoListModel mj_objectWithKeyValues:responseObject];
        
        cell.listModel.like_num = listModel.like_num;
        
        cell.listModel.is_liked = listModel.is_liked;
        
        listModel = cell.listModel;
        
        cell.listModel = listModel;
        
        
    } failure:^(NSError *error) {
        
        
    }];
    
}

- (void)shareWithListModel:(JGJVideoListModel *)listModel {
    
//    NSString *url =[NSString stringWithFormat:@"%@page/open-invite.html?uid=%@&plat=person", JGJWebDiscoverURL,uid];;
//title: 分享 ${data.user_info.real_name} 的贴子,
//summary: data.content || “分享了视频”,
//url: “https://nm.jgjapp.com/dynamic/info?id="data.id,
//pic: GLOBAL.imgUrl + data.pic_src[0]
    
    NSString *title = [NSString stringWithFormat:@"分享 %@ 的帖子", listModel.user_info.real_name ?:@""];
    
    NSString *desc = ![NSString isEmpty:listModel.cms_content] ?  listModel.cms_content : @"分享了视频";
    
    NSString *url =[NSString stringWithFormat:@"%@dynamic/info?id=%@", JGJWebDiscoverURL,listModel.post_id];
    
    NSString *img = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP_center, @"media/default_imgs/logo.jpg"];
    
    if (listModel.pic_src.count > 0) {
        
        img = [NSString stringWithFormat:@"%@%@", JLGHttpRequest_IP_center, listModel.pic_src.firstObject];
        
    }
    
    if (!self.shareMenuTool) {
        
        self.shareMenuTool = [[JGJKnowledgeDaseTool alloc] init];
        
        self.shareMenuTool.targetVc  = self;
        
        self.shareMenuTool.isUnCanShareCount = YES; //不清零
    }
    
    [self.shareMenuTool showShareBtnClick:img desc:desc title:title url:url];
    
}

//- (NSArray *)videoList{
//
//    if (!_videoList) {
//
//        NSMutableArray *datasource = [NSMutableArray array];
//
//        for(NSInteger index = 0; index < 20; index++) {
//
//            JGJVideoListModel *listModel = [JGJVideoListModel new];
//
//            listModel.video_url = @"http://120.25.226.186:32812/resources/videos/minion_01.mp4";
//
//            listModel.pic_src = @[@"http://img.wdjimg.com/image/video/cd47d8370569dbb9b223942674c41785_0_0.jpeg"];
//
//            JGJSynBillingModel *userinfo = [JGJSynBillingModel new];
//
//            userinfo.real_name = @"天天";
//
//            listModel.cms_content = @"为人我去二位二位额为我二位额为我饿为我二位额我二位额我二位额为我";
//
//            listModel.user_info = userinfo;
//
//            listModel.post_id = @"123";
//
//            [datasource addObject:listModel];
//        }
//
//        _videoList = datasource;
//    }
//
//    return _videoList;
//}


- (void)loadVideoList {
    
    self.request.postId = self.listModel.post_id;
    
    self.request.pg = 1;
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:@"video/socialvideolist" parameters:parameters success:^(id responseObject) {

        self.videoList = [JGJVideoListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (self.videoList.count < JGJPageSize) {
            
            self.tableView.mj_footer = nil;
            
            self.isLoadFinish = YES;
            
        }else {
            
            self.request.pg ++;
        }
        
        [self resetHeadView];
        
        [self.tableView reloadData];
        
//      播放第一个视频
        
        if (self.videoList.count > 0) {
            
            JGJVideoListModel *listModel = self.videoList.firstObject;
            
            if (!listModel.isUnAutoPlayFirstVideo) {
                
                [self playFirstVideo];
                
            }
            
        }

    } failure:^(NSError *error) {
        
        [self resetHeadView];
        
    }];
    
}

- (void)resetHeadView {
    
    self.tableView.mj_header = nil;
    
    [self.tableView.mj_header endRefreshing];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-15, 0, 0, 0);
}

#pragma mark - 播放第一个视频
- (void)playFirstVideo {
    
    if (self.tableView.visibleCells.count > 0) {
        
        JGJVideoListCell *cell = self.tableView.visibleCells[0];
        
        if (cell.playBlock) {
            
            cell.playBlock(nil, cell.listModel);
            
            self.playingCell = cell;
            
            cell.coverBottomView.alpha = 0;
            
            cell.coverVideoView.alpha = 0;
        }
        
    }
}

- (void)loadMoreVideoList {
    
    NSDictionary *parameters = [self.request mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithNapi:@"video/socialvideolist" parameters:parameters success:^(id responseObject) {
        
        NSArray *videoList = [JGJVideoListModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        if (videoList.count > 0) {
            
            self.request.pg ++;
            
            [self.videoList addObjectsFromArray:videoList];
            
        }
        
        if (videoList.count < JGJPageSize) {
            
            self.tableView.mj_footer = nil;
            
            self.isLoadFinish = YES;
        }
        
        [self.tableView.mj_footer endRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
}


- (JGJVideoListRequestModel *)request {
    
    if (!_request) {
        
        _request = [JGJVideoListRequestModel new];
        
        _request.pg = 1;
        
        _request.pagesize = JGJPageSize;
    }
    
    return _request;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
         _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
//         _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        // 静音
        // _playerView.mute = YES;
        // 移除屏幕移除player
        _playerView.stopPlayWhileCellNotVisable = YES;
        
        _playerView.forcePortrait = NO;
        
        ZFPlayerShared.isLockScreen = NO;
        
        ZFPlayerShared.isStatusBarHidden = NO;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {

    if (!_controlView) {

        _controlView = [[ZFPlayerControlView alloc] init];
        
        TYWeakSelf(self);
        
        _controlView.zfPlayerBlock = ^(NSInteger proMin, NSInteger proSec, NSInteger durMin, NSInteger durSec) {
            
            //获取播放时间s
            NSInteger seekTime = proSec + proMin * 60;
        };
    }
    return _controlView;
}

/**
 返回按钮响应
 */
- (void)backAction:(id)sender {
    
    if (self.navHiddenBlock) {
        
        self.navHiddenBlock();
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (JGJFooterViewInfoModel *)footerInfoModel {
    
    if (!_footerInfoModel) {
        
        _footerInfoModel = [JGJFooterViewInfoModel new];
        
        _footerInfoModel.backColor = [UIColor blackColor];
    
        _footerInfoModel.textColor = AppFont999999Color;
    
        _footerInfoModel.desType = UITableViewFooterDefaultType;
        
        _footerInfoModel.isHiddenLine = YES;
    }
    
    return _footerInfoModel;
    
}

@end

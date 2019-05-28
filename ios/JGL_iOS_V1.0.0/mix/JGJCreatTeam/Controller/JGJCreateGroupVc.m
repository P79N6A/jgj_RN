//
//  JGJCreateGroupVc.m
//  mix
//
//  Created by Tony on 2016/8/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//  我的二维码界面

#import "JGJCreateGroupVc.h"
#import "JGJQRCodeView.h"
#import "NSDate+Extend.h"
#import "UIImage+TYALAssetsLib.h"
#import "UIImage+TYCreateQRCode.h"
#import "JGJCusActiveSheetView.h"

#import "JGJCustomShareMenuView.h"

@interface JGJCreateGroupVc ()
<
    UIActionSheetDelegate
>
@property (weak, nonatomic) IBOutlet JGJQRCodeView *createView;

@end

@implementation JGJCreateGroupVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.createView.proListModel = self.workProListModel;
    self.createView.codeViewType = JGJQRCodeViewCreate;
    [self.createView superVc:self];
    NSInteger timestamp = [[[NSDate date] timestamp] integerValue];
    NSString *userUid = [TYUserDefaults objectForKey:JLGUserUid];
    NSString *classID = nil;
    if ([self.workProListModel.class_type isEqualToString:@"group"]) {
        classID = @"group_id";
        self.title = @"班组二维码";
    }else if ([self.workProListModel.class_type isEqualToString:@"team"]) {
        classID = @"team_id";
        self.title = @"项目组二维码";
    }else if ([self.workProListModel.class_type isEqualToString:@"groupChat"]) {
        classID = @"group_id";
        self.title = @"群二维码";
    }
    
    NSString *qrCodeUrl = [NSString stringWithFormat:@"%@%@?inviter_uid=%@&time=%@&class_type=%@&%@=%@",JLGHttpRequest_IP,@"v2/Qrcode/createQrCode",userUid,@(timestamp), self.workProListModel.class_type, classID, self.workProListModel.group_id];
    
    if ([self.workProListModel.class_type isEqualToString:@"addFriend"]) {
        NSString *headPic = nil;
        if (self.workProListModel.members_head_pic > 0) {
            headPic = [self.workProListModel.members_head_pic firstObject];
        }
        NSString *addFriendUrl = [NSString stringWithFormat:@"%@%@", JGJWebDiscoverURL, @"page/business-card.html"];
        qrCodeUrl = [NSString stringWithFormat:@"%@?uid=%@&time=%@&pic=%@&name=%@&class_type=%@",addFriendUrl,self.workProListModel.group_id,@(timestamp), headPic, self.workProListModel.group_name, self.workProListModel.class_type];
        self.title = @"我的吉工家二维码";
    }
    [self.createView createQRCodeImageWithUrl:qrCodeUrl];
    
    [self addRightItem];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.createView saveToAlbum];
    }
}

- (void)addRightItem {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存图片" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
}

- (void)rightItemPressed:(UIBarButtonItem *)item {
    
//    [self showSheetView];
    
    [self handleSavePic];
}

#pragma mark - 注册保存图片
- (void)handleSavePic{
    
    //type 0 普通分享 1朋友圈 2微信
    
    JGJShowShareMenuModel *shareModel = [JGJShowShareMenuModel new];
    
    shareModel.is_show_savePhoto = YES;
    
    if (shareModel.type == 0) {
        
        JGJCustomShareMenuView *shareMenuView = [[JGJCustomShareMenuView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];

        shareMenuView.Vc = self;

        [shareMenuView showCustomShareMenuViewWithShareMenuModel:shareModel];

        shareMenuView.shareButtonPressedBlock = ^(JGJShareMenuViewType type) {


        };
    }
    
}

- (void)showSheetView{
    
    __weak typeof(self) weakSelf = self;
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:@[@"保存图片", @"取消"] buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            [weakSelf saveQRcode];
        }
        
    }];
    
    [sheetView showView];
}

- (void)saveQRcode {
    
     [self.createView saveToAlbum];
}

@end

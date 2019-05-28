//
//  JGJKnowledgeDaseTool.m
//  mix
//
//  Created by yj on 2017/9/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKnowledgeDaseTool.h"

#import "SDWebImageManager.h"

//#import "UMSocialSnsService.h"

#import "AppDelegate+JLGThirdLib.h"

#import "JGJCustomShareMenuView.h"

@interface JGJKnowledgeDaseTool () <JGJCustomShareMenuViewDelegate>
//分享代码注释
//<
//
//    UMSocialUIDelegate
//>
@property (nonatomic, strong) JGJCustomShareMenuView *sharemenuView;

@end

@implementation JGJKnowledgeDaseTool

#pragma mark - 分享
- (void )showShareBtnClick:(NSString *)img desc:(NSString *)desc title:(NSString *)title url:(NSString *)url
{
    
    JGJCustomShareMenuView *sharemenuView = [[JGJCustomShareMenuView alloc] initWithFrame:TYKey_Window.bounds];
    
    sharemenuView.delegate = self;
    
    self.sharemenuView = sharemenuView;
    
    JGJShowShareMenuModel *shareMenuModel = [[JGJShowShareMenuModel alloc] init];
    
    shareMenuModel.title = title;
    
    shareMenuModel.imgUrl = img;
    
    shareMenuModel.describe = desc;
    
    shareMenuModel.url = url;
    
    sharemenuView.Vc = self.targetVc;
    
    sharemenuView.shareMenuModel = shareMenuModel;
    
    [sharemenuView showCustomShareMenuViewWithShareMenuModel:shareMenuModel];
    
    TYWeakSelf(self);
    
    sharemenuView.shareButtonPressedBlock = ^(JGJShareMenuViewType type) {
        
        //资料库默认是NO,项目设置YES.只有资料点击才清零
        if (!weakself.isUnCanShareCount) {
            
            [TYUserDefaults setObject:@(0) forKey:JGJKnowBaseShareCount];
            
        }
        
    };
}

@end


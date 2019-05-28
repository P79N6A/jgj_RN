//
//  JGJProiCloudMediaVc.m
//  JGJCompany
//
//  Created by YJ on 17/7/30.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudMediaVc.h"

//#import "UINavigationController+ZFPlayerRotation.h"

#import "ZFPlayer.h"

#import "JGJProiCloudTool.h"

@interface JGJProiCloudMediaVc () <

    ZFPlayerDelegate
>

@property (strong, nonatomic) ZFPlayerView *playerView;

@property (nonatomic, strong) ZFPlayerModel *playerModel;

@end

@implementation JGJProiCloudMediaVc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    if ([self.cloudListModel.file_broad_type.lowercaseString isEqualToString:@"video"]) {
        
        NSString * transFileUrl = self.cloudListModel.file_path;
        
        if ([JGJOSSCommonHelper isExistFile:transFileUrl]) {
            
            NSString *filePath = [transFileUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:filePath isDirectory:NO];
            
            self.playerModel.videoURL = fileUrl;
            
        }else {
            
            self.playerModel.videoURL = [NSURL URLWithString:self.cloudListModel.file_path];
        }
        
        self.playerModel.title = self.cloudListModel.file_name;
        
        [self.playerView autoPlayTheVideo];
        
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    
}

#pragma mark - ZFPlayerDelegate

/** 返回按钮事件 */
- (void)zf_playerBackAction {

     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        _playerView.hasDownload    = NO;
        
        // 打开预览图
        self.playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}

- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"";
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.view;
        //        _playerModel.resolutionDic = @{@"高清" : self.videoURL.absoluteString,
        //                                       @"标清" : self.videoURL.absoluteString};
    }
    return _playerModel;
}


@end

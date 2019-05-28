//
//  JGJKonwRepoWebViewVc.m
//  mix
//
//  Created by yj on 17/4/10.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJKonwRepoWebViewVc.h"
#import <QuickLook/QuickLook.h>
#import "NSString+Extend.h"

//#import "MobClick.h"

#import <UMAnalytics/MobClick.h>

@interface JGJKonwRepoWebViewVc ()<UIWebViewDelegate, UIDocumentInteractionControllerDelegate, QLPreviewControllerDelegate, QLPreviewControllerDataSource>

@property (nonatomic, strong)   UIWebView *webView;

@property (nonatomic,strong) UIButton *shareButton;//分享按钮

@property (nonatomic, strong) UIView *containSaveButtonView; //容纳保存按钮容器

@property (nonatomic,strong) UIButton *collecButton;//收藏按钮

@property (nonatomic, strong) JGJKnowBaseRequestModel *knowBaseCollecRequestModel;//知识库收藏，取消搜藏模型

@property (strong, nonatomic) QLPreviewController * previewController;
@end

@implementation JGJKonwRepoWebViewVc {
    
    UIDocumentInteractionController *_documentInteraction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.isHiddenBottomBtn) {
        
        [self containSaveButtonView];
    }
    
    [self setupSubViews];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

#pragma mark - Initialize data and view
- (void)setupSubViews {
    
    [self.view addSubview:self.previewController.view];
    
    [self addChildViewController:_previewController];
    
    if (self.isHiddenBottomBtn) {
        
        [self.previewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.and.right.bottom.offset(0);
            
        }];
        
    }else {
        
        [self.previewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.and.right.offset(0);
            make.bottom.equalTo(self.containSaveButtonView.mas_top);
        }];
        
    }
    
    //webView加载大文件容易闪退
    //    [self.view addSubview:self.webView];
    
    //    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.left.and.right.offset(0);
    //        make.bottom.equalTo(self.containSaveButtonView.mas_top);
    //    }];
    
    //    NSURL *url = [[NSURL alloc] initFileURLWithPath:self.knowBaseModel.localFilePath isDirectory:NO];
    //
    //    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //    // 设置缩放
    //    [self.webView setScalesPageToFit:YES];
    //
    //    [self.webView loadRequest:request];
    
    //    [TYLoadingHub showLoadingWithMessage:nil];
    TYLog(@"加载开始");
}

//- (UIWebView *)webView {
//    if (_webView == nil) {
//        _webView = [[UIWebView alloc]init];
//        _webView.backgroundColor = AppFontf1f1f1Color;
//        _webView.delegate= self;
//    }
//    return _webView;
//}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        //添加保存按钮
        _shareButton = [[UIButton alloc] init];
        [self.containSaveButtonView addSubview:_shareButton];
        _shareButton.backgroundColor = JGJMainColor;
        _shareButton.titleLabel.textColor = [UIColor whiteColor];
        [_shareButton setTitle:@"分享文件" forState:UIControlStateNormal];
        [_shareButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_shareButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.isHiddenColleclBtn) {
            
            [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.containSaveButtonView.mas_left).with.offset(10);
                make.right.mas_equalTo(self.containSaveButtonView.mas_right).with.offset(-10);
                make.height.mas_equalTo(@45);
                make.centerY.mas_equalTo(self.containSaveButtonView.centerY);
            }];
            
            
        }else {
            
            [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.collecButton.mas_right).with.offset(10);
                make.right.mas_equalTo(self.containSaveButtonView.mas_right).with.offset(-10);
                make.bottom.width.height.mas_equalTo(self.collecButton);
            }];
        }
    }
    return _shareButton;
}

- (UIButton *)collecButton {
    
    if (!_collecButton) {
        _collecButton = [[UIButton alloc] init];
        [self.containSaveButtonView addSubview:_collecButton];
        _collecButton.backgroundColor = [UIColor whiteColor];
        [_collecButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        NSString *buttonTilte = self.knowBaseModel.is_collection ? @"取消收藏" : @"收藏";
        [_collecButton setTitle:buttonTilte forState:UIControlStateNormal];
        [_collecButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_collecButton addTarget:self action:@selector(collecButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        CGFloat height = self.isHiddenColleclBtn ? 0 : 45;
//
//        CGFloat offset = self.isHiddenColleclBtn ? 0 : 10;
        
        [_collecButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.equalTo(@(45));
            
            make.left.equalTo(self.containSaveButtonView).offset(10);
            
            make.centerY.equalTo(self.containSaveButtonView);
            
        }];
        
    }
    
    return _collecButton;
}

- (UIView *)containSaveButtonView {
    if (!_containSaveButtonView) {
        _containSaveButtonView = [[UIView alloc] init];
        _containSaveButtonView.backgroundColor = AppFontfafafaColor;
        [self.view addSubview:_containSaveButtonView];
        [_containSaveButtonView addSubview:self.shareButton];
        [_containSaveButtonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@63);
            make.left.right.bottom.equalTo(self.view);
        }];
        UIView *lineViewTop = [[UIView alloc] init];
        lineViewTop.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewTop];
        [lineViewTop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
        UIView *lineViewBottom = [[UIView alloc] init];
        lineViewBottom.backgroundColor = AppFontdbdbdbColor;
        [_containSaveButtonView addSubview:lineViewBottom];
        [lineViewBottom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.left.equalTo(_containSaveButtonView);
            make.height.equalTo(@1);
        }];
    }
    return _containSaveButtonView;
}


- (void)cancelBtnClick:(UIButton *)button {
    
    
}

- (void)shareBtnClick:(UIButton *)button {
    
    if (![NSString isEmpty:self.knowBaseModel.localFilePath]) {
        
        NSString *filePath = [self.knowBaseModel.localFilePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:filePath isDirectory:NO];
        
        _documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileUrl];
        
        _documentInteraction.delegate = self; // UIDocumentInteractionControllerDelegate
        
        [_documentInteraction presentOpenInMenuFromRect:button.bounds inView:button animated:YES];
        
        [MobClick event:@"share_repository"];
    }
    
}

#pragma mark - UIDocumentInteractionControllerDelegate methods

#pragma mark - 在此代理处加载需要显示的文件

-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    
    return 1;
}

- (id<QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:self.knowBaseModel.localFilePath?:@"" isDirectory:NO];
    
    if (![NSString isEmpty:self.knowBaseModel.localFilePathURL.absoluteString]) {
        
        url = self.knowBaseModel.localFilePathURL;
    }
    
    return url;
}

#pragma mark - 即将要退出浏览文件时执行此方法
-(void)previewControllerWillDismiss:(QLPreviewController *)controller {
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    _documentInteraction = nil;
}

#pragma mark - UIWebViewDelegate
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    TYLog(@"加载完成");
//
//    [TYLoadingHub hideLoadingView];
////    [SVProgressHUD dismiss];
//}

#pragma mark- 收藏和取消收藏按钮按下

- (void)collecButtonClick:(UIButton *)sender {
    
    if (![self checkIsLogin]) {
        
        return;
    }
    
    [self handleCollecKnowRepo];
    
}

-(BOOL)checkIsLogin{
    
    SEL checkIsLogin = NSSelectorFromString(@"checkIsLogin");
    IMP imp = [self.navigationController methodForSelector:checkIsLogin];
    BOOL (*func)(id, SEL) = (void *)imp;
    if (!func(self.navigationController, checkIsLogin)) {
        return NO;
    }else{
        return YES;
    }
}

- (void)handleCollecKnowRepo {
    
    self.knowBaseCollecRequestModel.id = self.knowBaseModel.knowBaseId;
    
    //已经是收藏的情况，点击取消收藏，否则就是搜藏 @"2" 取消收藏 @"1"收藏
    self.knowBaseCollecRequestModel.class_type = self.knowBaseModel.is_collection ? @"2" : @"1";
    
    NSDictionary *parameters = [self.knowBaseCollecRequestModel mj_keyValues];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/knowledge/handleCollectionFile" parameters:parameters success:^(id responseObject) {
        
        NSString *tips = self.knowBaseModel.is_collection ? @"已从资料收藏夹移除" : @"已加入到资料收藏夹";
        
        self.knowBaseModel.is_collection = !self.knowBaseModel.is_collection;
        
        //更改childVc收藏状态
        [TYNotificationCenter postNotificationName:@"ClickedCancelKnowBase" object:self.knowBaseModel];
        
        NSString *buttonTilte = self.knowBaseModel.is_collection ? @"取消收藏" : @"收藏";
        
        [self.collecButton setTitle:buttonTilte forState:UIControlStateNormal];
        
        [TYShowMessage showSuccess:tips];
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (JGJKnowBaseRequestModel *)knowBaseCollecRequestModel {
    
    if (!_knowBaseCollecRequestModel) {
        
        _knowBaseCollecRequestModel = [JGJKnowBaseRequestModel new];
        
    }
    
    return _knowBaseCollecRequestModel;
}

- (QLPreviewController *)previewController {
    
    if (!_previewController) {
        
        _previewController =[[QLPreviewController alloc]init];
        
        _previewController.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        
        _previewController.view.backgroundColor = [UIColor orangeColor];
        
        _previewController.delegate = self;
        
        _previewController.dataSource = self;
        
    }
    
    return _previewController;
}

@end

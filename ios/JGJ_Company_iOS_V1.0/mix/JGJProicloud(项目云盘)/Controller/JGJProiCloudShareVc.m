//
//  JGJProiCloudShareVc.m
//  JGJCompany
//
//  Created by yj on 2017/8/1.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJProiCloudShareVc.h"

#import <QuickLook/QuickLook.h>

#import "NSString+Extend.h"

#import "JGJProiCloudTool.h"

@interface JGJProiCloudShareVc ()<

    UIDocumentInteractionControllerDelegate,

    QLPreviewControllerDelegate,

    QLPreviewControllerDataSource
>

@property (nonatomic,strong) UIButton *shareButton;//分享按钮

@property (nonatomic, strong) UIView *containSaveButtonView; //容纳保存按钮容器

@property (nonatomic,strong) UIButton *collecButton;//收藏按钮

@property (strong, nonatomic) QLPreviewController * previewController;

@end

@implementation JGJProiCloudShareVc{
    
    UIDocumentInteractionController *_documentInteraction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self containSaveButtonView];
    
    [self setupSubViews];
    
    self.title = self.cloudListModel.file_name;
    
    if ([self.cloudListModel.file_broad_type isEqualToString:@"zip"]) {
        
        [TYShowMessage showHUDOnly:@"暂不支持该格式"];
    }
    
}


#pragma mark - Initialize data and view
- (void)setupSubViews {
    
    [self.view addSubview:self.previewController.view];
    
    [self addChildViewController:_previewController];
    
    [self.previewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(0);
        
    }];
    
}

- (void)shareBtnClick:(UIButton *)button {
    
    if (![NSString isEmpty:self.cloudListModel.file_path]) {
        
        NSString * url = FILE_PATH(self.cloudListModel.file_name);
        
        NSString *filePath = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *fileUrl = [[NSURL alloc] initFileURLWithPath:filePath isDirectory:NO];
        
        _documentInteraction = [UIDocumentInteractionController interactionControllerWithURL:fileUrl];
        
        _documentInteraction.delegate = self; // UIDocumentInteractionControllerDelegate
        
        [_documentInteraction presentOpenInMenuFromRect:button.bounds inView:button animated:YES];
        
    }
    
}

- (void)delButtonClick:(UIButton *)sender {


}

#pragma mark - UIDocumentInteractionControllerDelegate methods

#pragma mark - 在此代理处加载需要显示的文件
- (NSURL *)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSString * filePath = FILE_PATH(self.cloudListModel.file_name);
    
    NSString *encodeFilePath = [filePath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:encodeFilePath isDirectory:NO];
    
    return url;
}

#pragma mark - 返回文件的个数
-(NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {

    return 1;
}
#pragma mark - 即将要退出浏览文件时执行此方法
-(void)previewControllerWillDismiss:(QLPreviewController *)controller {
    
}

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    _documentInteraction = nil;
}

- (QLPreviewController *)previewController {
    
    if (!_previewController) {
        
        _previewController =[[QLPreviewController alloc]init];
        
        _previewController.view.backgroundColor = [UIColor whiteColor];
        
        _previewController.delegate=self;
        
        _previewController.dataSource=self;
        
    }
    
    return _previewController;
}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        //添加保存按钮
        _shareButton = [[UIButton alloc] init];
        [self.containSaveButtonView addSubview:_shareButton];
        _shareButton.backgroundColor = JGJMainColor;
        _shareButton.titleLabel.textColor = [UIColor whiteColor];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_shareButton addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.collecButton.mas_right).with.offset(10);
            make.right.mas_equalTo(self.containSaveButtonView.mas_right).with.offset(-10);
            make.bottom.width.height.mas_equalTo(self.collecButton);
        }];
    }
    return _shareButton;
}

- (UIButton *)collecButton {
    
    if (!_collecButton) {
        _collecButton = [[UIButton alloc] init];
        [self.containSaveButtonView addSubview:_collecButton];
        _collecButton.backgroundColor = [UIColor whiteColor];
        [_collecButton setTitleColor:AppFontd7252cColor forState:UIControlStateNormal];
        NSString *buttonTilte = @"删除";
        [_collecButton setTitle:buttonTilte forState:UIControlStateNormal];
        [_collecButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
        [_collecButton addTarget:self action:@selector(delButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_collecButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@45);
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

@end

//
//  JGJDredgeWeChatServiceViewController.m
//  mix
//
//  Created by Tony on 2018/9/18.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJDredgeWeChatServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "UIImage+TYCreateQRCode.h"
#import "UIImage+TYALAssetsLib.h"
#import "JGJCustomPopView.h"
#import "JGJDredgeWeChatFialeView.h"
#import "JGJDredgeWeChatSuccessView.h"
#import "JGJCusActiveSheetView.h"
@interface JGJDredgeWeChatServiceViewController ()
{
    
    NSString *_codeUrl;
    NSInteger _codeStatus;
}

@property (nonatomic, strong) JGJDredgeWeChatFialeView *dredgeWeChatFiale;
@property (nonatomic, strong) JGJDredgeWeChatSuccessView *dredgeWeChatSuccess;

@end

@implementation JGJDredgeWeChatServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"开通微信服务";
    self.view.backgroundColor = AppFontf1f1f1Color;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endBackground) name:UIApplicationWillEnterForegroundNotification object:nil];

    [self.view addSubview:self.dredgeWeChatFiale];
    [self.view addSubview:self.dredgeWeChatSuccess];
    TYWeakSelf(self);
    _dredgeWeChatFiale.saveQrCodePicture = ^{// 保存二维码，并打开微信
      
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        
        [weakself.dredgeWeChatFiale.qrcodeImage.image saveToAlbum:appName completionBlock:^{
            
            [TYShowMessage showSuccess:@"已保存到手机相册"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [weakself openWeChatScanQrCode];
            });
            
        } failureBlock:^(NSError *error) {
            
            [TYShowMessage showError:@"保存图片失败"];
        }];
    };
    

    [_dredgeWeChatFiale mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.top.right.bottom.offset(0);

    }];
    
    [_dredgeWeChatSuccess mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.offset(0);
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
}

- (void)endBackground {
    
    [self getWXStatus];
}

- (void)getWXStatus {
    
    [JLGHttpRequest_AFN PostWithNapi:@"wxchat/get-wx-status" parameters:nil success:^(id responseObject) {
        
        self.status = [responseObject[@"status"] integerValue];
        
    } failure:^(NSError *error) {
        
        
    }];
}

- (void)getWXQrcode {
    
    [JLGHttpRequest_AFN PostWithNapi:@"wxchat/create-wx-qrcode" parameters:nil success:^(id responseObject) {
        
        _codeUrl = responseObject[@"url"];
        self.dredgeWeChatFiale.codeUrl = _codeUrl;
    } failure:^(NSError *error) {
        
    }];
}

- (void)setStatus:(NSInteger)status {
    
    _status = status;
    if (_status == 0) {// 未开通
        
        [self getWXQrcode];
        self.dredgeWeChatFiale.hidden = NO;
        self.dredgeWeChatSuccess.hidden = YES;
        
    }else {// 已开通
        
        self.dredgeWeChatFiale.hidden = YES;
        self.dredgeWeChatSuccess.hidden = NO;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemPressed:)];
    }
    
}

- (void)rightItemPressed:(UIBarButtonItem *)item {
    
    __weak typeof(self) weakSelf = self;
    JGJCusActiveSheetView *sheetView = [[JGJCusActiveSheetView alloc] initWithTitle:@"" sheetViewType:JGJCusActiveSheetViewBoldPaddingType chageColors:@[@""] buttons:@[@"解除绑定", @"取消"] buttonClick:^(JGJCusActiveSheetView *sheetView, NSInteger buttonIndex, NSString *title) {
        
        if (buttonIndex == 0) {
            
            JGJShareProDesModel *desModel = [[JGJShareProDesModel alloc] init];
            
            desModel.popDetail = @"解除绑定可能导致错过重要的工作信息和活动消息";
            
            desModel.leftTilte = @"以后再说";
            
            desModel.rightTilte = @"解绑";
            
            JGJCustomPopView *alertView = [JGJCustomPopView showWithMessage:desModel];
            
            __weak typeof(self) weakSelf = self;
            
            alertView.onOkBlock = ^{
                
                [JLGHttpRequest_AFN PostWithNapi:@"wxchat/get-wx-unbound" parameters:nil success:^(id responseObject) {
                    
                    [TYShowMessage showSuccess:@"解绑成功"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                    
                } failure:^(NSError *error) {
                    
                }];
            };
        }
        
    }];
    
    [sheetView showView];
}


//直接打开WXApp
- (void)openWeChatScanQrCode {
    
    //创建一个url，这个url就是WXApp的url，记得加上：//
    NSURL *url = [NSURL URLWithString:@"weixin://scanqrcode"];
    
    //打开url
    [[UIApplication sharedApplication] openURL:url];
}

- (JGJDredgeWeChatFialeView *)dredgeWeChatFiale {
    
    if (!_dredgeWeChatFiale) {
        
        _dredgeWeChatFiale = [[JGJDredgeWeChatFialeView alloc] init];
    }
    return _dredgeWeChatFiale;
}

- (JGJDredgeWeChatSuccessView *)dredgeWeChatSuccess {
    
    if (!_dredgeWeChatSuccess) {
        
        _dredgeWeChatSuccess = [[JGJDredgeWeChatSuccessView alloc] init];
        _dredgeWeChatSuccess.backgroundColor = [UIColor whiteColor];
    }
    return _dredgeWeChatSuccess;
}


@end

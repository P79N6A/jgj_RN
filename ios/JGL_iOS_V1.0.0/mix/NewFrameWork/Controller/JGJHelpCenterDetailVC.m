//
//  JGJHelpCenterDetailVC.m
//  mix
//
//  Created by yj on 16/10/8.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJHelpCenterDetailVC.h"
#import "JLGCustomViewController.h"
@interface JGJHelpCenterDetailVC ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *detailTitleLable;

@end

@implementation JGJHelpCenterDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助中心详情";
    self.detailTitleLable.text = self.helpCenterListModel.title;
//     self.webView.scalesPageToFit = YES;
    [self.webView.layer setLayerBorderWithColor:AppFontdbdbdbColor width:1 radius:2.5];
    [self.webView loadHTMLString:self.helpCenterListModel.content baseURL:nil];
//    self.navigationItem.leftBarButtonItem = [self getLeftBarButton];
}

//- (UIBarButtonItem *)getLeftBarButton{
//    JLGCustomViewController *navVc = (JLGCustomViewController *)self.navigationController;
//    UIButton *whiteLeftButton = [navVc getLeftButton];
//    [whiteLeftButton addTarget:self action:@selector(helpCenterDetailVcGoBack) forControlEvents:UIControlEventTouchUpInside];
//    return [[UIBarButtonItem alloc ] initWithCustomView:whiteLeftButton];
//}

//- (void)helpCenterDetailVcGoBack {
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

//
//  JGJPaySuccesViewController.m
//  JGJCompany
//
//  Created by Tony on 2017/8/15.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJPaySuccesViewController.h"
#import "JGJViewController.h"
#import "UILabel+GNUtil.h"
#import "JGJOrderDetailViewController.h"
@interface JGJPaySuccesViewController ()
@property(nonatomic, strong)JGJOrderListModel *detailModel;
@end

@implementation JGJPaySuccesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"支付成功";
    _popButton.layer.masksToBounds = YES;
    _popButton.layer.cornerRadius = 2.5;
    _popButton.layer.borderColor = AppFont666666Color.CGColor;
    _popButton.layer.borderWidth = 0.5;
    _detailButton.layer.masksToBounds = YES;
    _detailButton.layer.cornerRadius = 2.5;
    _detailButton.layer.borderColor = AppFont666666Color.CGColor;
    _detailButton.layer.borderWidth = 0.5;
    [_telLable markText:@"400-862-3818" withColor:AppFontEB4E4EColor];
    _telLable.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(callPhone)];
    [_telLable addGestureRecognizer:tap];
}
-(void)callPhone
{
    NSString * str=[NSString stringWithFormat:@"tel:%@",@"4008623818"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];


}
-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationItem.hidesBackButton = YES;
//    self.navigationItem.leftBarButtonItem = nil;
//    self.navigationItem.backBarButtonItem = nil;
    UIButton * btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(0, 0, 60, 30);
    [btn setTitle:@"" forState:UIControlStateNormal];
    UIImage * bImage = [[UIImage imageNamed:@""]
                        resizableImageWithCapInsets: UIEdgeInsetsMake(0, -20, 0, 0)];
    [btn setImage: bImage forState: UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    UIBarButtonItem * lb = [[UIBarButtonItem alloc] initWithCustomView: btn];
    self.navigationItem.leftBarButtonItem = lb;
    [super viewWillAppear:animated];
}
//返回首页
- (IBAction)popHomeVC:(id)sender {
//    for (UIViewController *vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[JGJViewController class]]) {
//            [self.navigationController popToViewController:(JGJViewController *)vc animated:YES];
//        }
//    }
//    
    __weak typeof(self) weakSelf = self;
    
    JGJTabBarViewController *vc = (JGJTabBarViewController *)weakSelf.navigationController.parentViewController;
    
    if ([vc isKindOfClass:[JGJTabBarViewController class]]) {
        
        vc.selectedIndex = 0;
        
    }
    
    
    [weakSelf.navigationController popToRootViewControllerAnimated:NO];
    

}
-(void)setTrade_no:(NSString *)trade_no
{
    _trade_no = trade_no;

}
//查看订单详情
- (IBAction)lookForDetail:(id)sender {
    
    JGJOrderDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"JGJOrderDetailVC" bundle:nil] instantiateViewControllerWithIdentifier:@"JGJOrderDetailVC"];
    detailVC.trade_no = _trade_no;
    [self.navigationController pushViewController:detailVC animated:YES];
}

@end

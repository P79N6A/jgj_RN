//
//  JLGCitysListViewController.m
//  mix
//
//  Created by Tony on 16/1/21.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JLGCitysListViewController.h"
#import "JLGCitysListView.h"

@interface JLGCitysListViewController ()
<
    JLGCitysListViewDelegate
>
@property (weak, nonatomic) IBOutlet JLGCitysListView *cityListView;
@end

@implementation JLGCitysListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cityListView.delegate = self;
    
    [self overSetleftBarButtonItem];
    
    NSString *postApi = self.roleType == 1?@"jlwork/cityprolist":@"jlforemanwork/cityprolist";
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:postApi parameters:nil success:^(NSDictionary *responseObject) {
//        weakSelf.cityListView.dataDic = responseObject;
        [weakSelf.cityListView tableViewReloadData];
    }];
}

#pragma mark - 选中了城市
- (void)selectedCity:(NSString *)cityCode cityName:(NSString *)cityName{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedCityVc:cityCode:cityName:)]) {
        [self.delegate selectedCityVc:self cityCode:cityCode cityName:cityName];
    }
}

- (void)overSetleftBarButtonItem{
    //重写leftBarButtonItem
    UIButton *leftButton = [[UIButton alloc] initWithFrame:TYSetRect(0, 0, 40, 44)];
    
    leftButton.backgroundColor = [UIColor clearColor];
    
    [leftButton setImage:[UIImage imageNamed:@"barButtonItem_back"]  forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backToVc) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -12, 0, 0)];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    //添加一个透明的item填充在左边
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -12;
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftItem];
}

- (void)backToVc{
    [self dismissViewControllerAnimated:YES completion:^{
        self.delegate = nil;
    }];
}

@end

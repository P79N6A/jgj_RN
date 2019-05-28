//
//  JGJNotiFyDetailViewController.m
//  mix
//
//  Created by Tony on 2016/12/23.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJNotiFyDetailViewController.h"
#import "JGJNotiFicationView.h"
#import "JGJNotificationDetailTableViewCell.h"
#define MainScreen  [UIScreen mainScreen].bounds.size
@interface JGJNotiFyDetailViewController ()<UITableViewDelegate ,UITableViewDataSource>
{
// headerView 的显示图片的view
    UIView *backview;
}
@property(nonatomic ,strong)JGJNotiFicationView *NewsDetailView;
@property(nonatomic ,strong)UITableView *detailTableview;

@end

@implementation JGJNotiFyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initInterFace];
  }
-(void)initInterFace{



    [self.view addSubview:self.detailTableview];
    [self.navigationController.navigationBar setBarTintColor:[UIColor darkTextColor]];
}

-(JGJNotiFicationView *)NewsDetailView
{
    if (!_NewsDetailView) {
        _NewsDetailView = [[JGJNotiFicationView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-10, 150)];
    }

    return _NewsDetailView;

}

-(UITableView *)detailTableview
{
    if (!_detailTableview) {
        _detailTableview = [UITableView new];
        [_detailTableview setFrame:CGRectMake(0, 0, MainScreen.width, MainScreen.height-60)];
        _detailTableview.dataSource =self;
        _detailTableview.delegate = self;
        UIView *view = [[[NSBundle mainBundle]loadNibNamed:@"NotificationDeatail" owner:self options:nil]firstObject];
        UILabel *lable = [view viewWithTag:1111];
        [view setFrame:CGRectMake(0, 0, MainScreen.width, CGRectGetMaxY(lable.frame)+10)];
        backview = [view viewWithTag:111];
        backview.backgroundColor = [UIColor clearColor];
        [backview addSubview:self.NewsDetailView];
        _detailTableview.tableHeaderView = view;

    }
    return _detailTableview;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   static NSString *cellIndentifer = @"MyCellIndentifer";
    JGJNotificationDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"JGJNotificationDetailTableViewCell" owner:nil options:nil] firstObject];
    }

    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 4;


}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 80;

}
@end

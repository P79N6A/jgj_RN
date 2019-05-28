//
//  JGJSelectProViewController.m
//  mix
//
//  Created by Tony on 2017/6/19.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSelectProViewController.h"
#import "JGJMoreDayViewController.h"
#import "YZGOnlyAddProjectViewController.h"
#import "JGJSelectMoreDayProTableViewCell.h"
@interface JGJSelectProViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic,strong)NSMutableArray *DataArr;

@end

@implementation JGJSelectProViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _proTableview.dataSource = self;
    _proTableview.delegate  =self;
    _proTableview.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
//    [self getProAPI];
    self.title = @"选择项目";
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"新建项目" style:UIBarButtonItemStylePlain target:self action:@selector(singerRecod)];
    self.navigationItem.rightBarButtonItem = rightBarItem;

    // Do any additional setup after loading the view from its nib.
}
- (void)singerRecod
{
    YZGOnlyAddProjectViewController *onlyAddProVc = [[UIStoryboard storyboardWithName:@"RecordMateWorkpoints" bundle:nil] instantiateViewControllerWithIdentifier:@"onlyAddProject"];
    
    BOOL superViewIsGroup;//上个界面是不是组合界面，YES:是，NO，不是
    //    superViewIsGroup = self.delegate && [self.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)];
    onlyAddProVc.superViewIsGroup = superViewIsGroup;
    onlyAddProVc.isPopUpVc = YES;
    //    if (self.delegate && [self.delegate respondsToSelector:@selector(MateGetBillPush:ByVc:)]) {
    //        [self.delegate MateGetBillPush:self ByVc:onlyAddProVc];
    //    }else{
    [self.navigationController pushViewController:onlyAddProVc animated:YES];


}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJSelectMoreDayProTableViewCell *cell = [JGJSelectMoreDayProTableViewCell cellWithTableView:tableView];
    cell.pronameLable.textColor = AppFont333333Color;
    cell.pronameLable.font = [UIFont systemFontOfSize:15];
    cell.slectImage.hidden = YES;
    cell.hadLable.hidden = YES;
    if (![NSString isEmpty:_pidStr]) {
        
        if ([[NSString stringWithFormat:@"%@", _DataArr[indexPath.row][@"pid"] ]  isEqualToString: _pidStr]) {
            
            cell.slectImage.hidden = NO;
            cell.hadLable.hidden = NO;
        }
    }
    cell.pronameLable.text = _DataArr[indexPath.row][@"pro_name"];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataArr.count;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getProAPI];

}
-(void)getProAPI
{
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/querypro" parameters:nil success:^(NSArray * responseObject) {
        _DataArr = [[NSMutableArray alloc]initWithArray:responseObject];
        [_proTableview reloadData];
    }failure:^(NSError *error) {
    }];


}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[JGJMoreDayViewController class]]) {
            
            JGJMoreDayViewController *moreVC = (JGJMoreDayViewController *)vc;
            moreVC.JlgGetBillModel.proname = _DataArr[indexPath.row][@"pro_name"];
            moreVC.JlgGetBillModel.pid = [_DataArr[indexPath.row][@"pid"] integerValue];
        }
    }

    [self.navigationController popViewControllerAnimated:YES];

}
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

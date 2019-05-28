//
//  JGJMoreDayFitSizeViewController.m
//  mix
//
//  Created by Tony on 2017/2/25.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJMoreDayFitSizeViewController.h"
#import "JGJPepleInfoTableViewCell.h"
#import "JGJFSCalendarTableViewCell.h"
#import "JGJDesWorkTableViewCell.h"
#import "JGJSureButtonTableViewCell.h"
#import "FSCalendar.h"
#import "JGJGetViewFrame.h"
#import <EventKit/EventKit.h>
#import "JGJTime.h"
#import "JLGPickerView.h"
#import "JGrecordWorkTimePickerview.h"
#import "NSString+Extend.h"
#import "NSDate+Extend.h"
#import "YZGDatePickerView.h"
@interface JGJMoreDayFitSizeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
FSCalendarDataSource,
FSCalendarDelegate,
FSCalendarHeaderDelegate


>
{
    JGJFSCalendarTableViewCell *calendarCell;

}
@property(nonatomic ,strong)UITableView *tableview;
@property(nonatomic ,strong)FSCalendar *calendar;

@end

@implementation JGJMoreDayFitSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableview];
    // Do any additional setup after loading the view from its nib.
}

-(UITableView *)tableview
{
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight)];
        _tableview.delegate = self;
        _tableview.dataSource =self;
    }
    return _tableview;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        JGJPepleInfoTableViewCell *peopleInfoCell = [JGJPepleInfoTableViewCell cellWithTableView:tableView];
        cell = peopleInfoCell;
    }else if (indexPath.row == 1){
       calendarCell = [JGJFSCalendarTableViewCell cellWithTableView:tableView];
        cell = calendarCell;
    
    }else if (indexPath.row == 2){
    
        JGJDesWorkTableViewCell *desWorkCell = [JGJDesWorkTableViewCell cellWithTableView:tableView];
        cell = desWorkCell;
    }else{
        JGJSureButtonTableViewCell *buttoncell = [JGJSureButtonTableViewCell cellWithTableView: tableView];
        cell = buttoncell;
    }
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 4;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{



}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return 80;
            break;
        case 1:
            return 350;
            break;
        case 2:
            return 30;
            break;
        case 3:
            return 45;
            break;
        default:
            break;
    }

    return 0;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)calendarCurrentPageDidChange:(FSCalendar *)calendar
{
    
    
    
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

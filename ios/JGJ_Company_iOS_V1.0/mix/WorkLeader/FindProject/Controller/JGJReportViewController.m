//
//  JGJReportViewController.m
//  mix
//
//  Created by Tony on 16/4/19.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJReportViewController.h"
#import "NSString+Extend.h"
#import "JGJReportTableViewCell.h"
#import "JLGSendProjectTableViewCell.h"
#import "UIView+GNUtil.h"
@interface JGJReportViewController ()
<
    JGJReportTableViewCellDelegate,
    JLGSendProjectTableViewCellDelegate
>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy) NSString *otherString;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomH;
@property (assign, nonatomic) CGFloat textViewHeight;
@end

@implementation JGJReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [TYLoadingHub showLoadingWithMessage:@""];
    [JLGHttpRequest_AFN PostWithApi:@"jlcfg/classlist" parameters:@{@"class_id":@(40)} success:^(NSArray *responseObject) {
        self.reportsArray = [JGJReportModel mj_objectArrayWithKeyValuesArray:responseObject];
        
        JGJReportModel *reportModel = [[JGJReportModel alloc] init];
        reportModel.selected = NO;
        reportModel.name = @"其他";
        reportModel.desc = [NSString string];
        [self.reportsArray addObject:reportModel];
        
        [self.tableView reloadData];
        [TYLoadingHub hideLoadingView];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
#if TYKeyboardObserver
    [TYNotificationCenter addObserver:self selector:@selector(ReportKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
#endif
}

#if TYKeyboardObserver
#pragma mark - 监控键盘
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)ReportKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect beginKeyboardRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = beginKeyboardRect.origin.y - endKeyboardRect.origin.y;
    
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        //显示
        self.bottomViewBottomH.constant += yOffset;
        
        //contentOffset
        if (yOffset > 100) {
            self.tableView.contentOffset = CGPointMake(0, self.tableView.y + 200);
        }else if(yOffset < -100){
            self.tableView.contentOffset = CGPointMake(0, 0);
        }
        [self.tableView layoutIfNeeded];
    }];
}

- (void)dealloc {
    [TYNotificationCenter removeObserver:self];
}
#endif

#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.reportsArray.count + 1;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.reportsArray.count == 0) {
        return 0;
    }

    if ((self.reportsArray.count - 1) > indexPath.row) {
        return 80;
    }else if((self.reportsArray.count - 1) == indexPath.row){
        JGJReportModel *reportModel = self.reportsArray[indexPath.row];
        return reportModel.selected?MAX(140.0, self.textViewHeight):80.0;
    }else{
        return 70;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (self.reportsArray.count == 0) {
        return [UITableViewCell getNilViewCell:tableView indexPath:indexPath];
    }
    
    if (indexPath.row <= (self.reportsArray.count - 1)) {
        JGJReportModel *reportModel = self.reportsArray[indexPath.row];
        JGJReportTableViewCell *reportCell = [JGJReportTableViewCell cellWithTableView:tableView];
        indexPath.row == (self.reportsArray.count - 1)?[reportCell setReportType:JGJReportTypeOther setReportModel:reportModel]:[reportCell setReportType:JGJReportTypeNormal setReportModel:reportModel];
        
        if (indexPath.row == self.reportsArray.count - 1) {
            reportCell.otherDescTextView.text = self.otherString;
        }
        reportCell.delegate = self;
        cell = reportCell;
    }else{
        JLGSendProjectTableViewCell *returnCell = [JLGSendProjectTableViewCell cellWithTableView:tableView];
        returnCell.titleString = @"提交";
        returnCell.delegate = self;
        returnCell.backColor = [UIColor whiteColor];
        cell = returnCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JGJReportModel *reportModel = self.reportsArray[indexPath.row];
    reportModel.selected = !reportModel.selected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 其他里面的内容改变了
- (void)JGJReportTextChange:(JGJReportTableViewCell *)reportCell textString:(NSString *)textString{
    if ([textString isEqualToString:@"请输入"] || textString.length == 0){
        return;
    }
    self.otherString = textString;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:reportCell];
    CGFloat newHeight = [reportCell.otherDescTextView sizeThatFits:CGSizeMake(reportCell.otherDescTextView.frame.size.width, FLT_MAX)].height;
    newHeight =  MAX(140.0, newHeight + 80.0);
    CGFloat oldHeight = [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
    if (fabs(newHeight - oldHeight) > 0.01) {
        self.textViewHeight = newHeight;
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

#pragma mark - 提交
-(void)sendProjectCellBtnClick{
    [self.view resignFirstResponder];
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    
    parametersDic[@"mstype"] = @"recruit";
    parametersDic[@"key"] = self.pid;
    
    //选择的项
    __weak typeof(self) weakSelf = self;
    __block NSMutableArray *valuesArray = [NSMutableArray array];
    [self.reportsArray enumerateObjectsUsingBlock:^(JGJReportModel *reportModel, NSUInteger idx, BOOL *  stop) {
        if (idx > weakSelf.reportsArray.count - 2) {
            return ;//最后一个没有code
        }

        if (reportModel.selected) {
            [valuesArray addObject:reportModel.code];
        }
    }];
    
    if (valuesArray.count == 0 && [NSString isEmpty:self.otherString] ) {
        [TYShowMessage showPlaint:@"请输入其他的举报内容"];
        return;
    }
    parametersDic[@"value"] = [valuesArray componentsJoinedByString:@","];
    parametersDic[@"other"] = self.otherString;
    
    [JLGHttpRequest_AFN PostWithApi:@"jlwork/report" parameters:parametersDic success:^(id responseObject) {
        [TYShowMessage showSuccess:@"提交成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [TYShowMessage showPlaint:@"提交失败"];
    }];
}

@end

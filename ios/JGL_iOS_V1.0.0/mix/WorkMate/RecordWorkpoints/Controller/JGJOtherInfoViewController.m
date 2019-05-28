//
//  JGJOtherInfoViewController.m
//  mix
//
//  Created by Tony on 16/4/25.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJOtherInfoViewController.h"
#import "JGJQRecordViewController.h"
#import "JGJMarkBillViewController.h"

static const CGFloat kNormalCellHeight = 44;
static const CGFloat kAudioCellHeight = 280;//,有语音的cell

@interface JGJOtherInfoViewController ()
<
    JLGDatePickerViewDelegate,
    YZGAudioAndPicTableViewCellDelegate
>

@property (nonatomic,copy)   NSArray *cellDataArray;
@property (nonatomic,strong) JLGDatePickerView *jlgDatePickerView;
@property (nonatomic,assign) CGFloat cellTextViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomH;
@end

@implementation JGJOtherInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
#if TYKeyboardObserver
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [TYNotificationCenter addObserver:self selector:@selector(OtherInfoKeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
#endif
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [self.view endEditing:YES];
#if TYKeyboardObserver
    [TYNotificationCenter removeObserver:self];
#endif
}

#if TYKeyboardObserver
#pragma mark - 监控键盘
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)OtherInfoKeyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect beginKeyboardRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = beginKeyboardRect.origin.y - endKeyboardRect.origin.y;
    
    [self OtherInfoKeyboradChangeYOffset:yOffset duration:duration];
}

- (void)OtherInfoKeyboradChangeYOffset:(CGFloat )yOffset duration:(double) duration{
    __weak typeof(self) weakSelf = self;
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        //显示
        weakSelf.bottomViewBottomH.constant += yOffset;
        [weakSelf.tableView layoutIfNeeded];
    }];
}
#endif

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    NSInteger section = self.yzgGetBillModel.accounts_type.code == 2?1:0;
    YZGAudioAndPicTableViewCell *audioCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    if (audioCell) {
        [audioCell configAudioData:self.yzgGetBillModel parametersDic:self.parametersDic deleteImgsArray:self.deleteImgsArray imagesArray:self.imagesArray];
    }
    
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"JGJMarkBillViewController")]) {
            JGJMarkBillViewController *recordVc = (JGJMarkBillViewController *)vc;
            recordVc.remarkYzgGetBillModel = self.yzgGetBillModel;
            recordVc.parametersDic = self.parametersDic;
            recordVc.imagesArray = self.imagesArray;
            break;
        }
        
    }
    
    
    [self.navigationController.viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(@"JGJMarkBillBaseVc")] || [obj isKindOfClass:NSClassFromString(@"YZGMateReleaseBillViewController")]) {
            
            SEL RefreshOtherInfo = NSSelectorFromString(@"RefreshOtherInfo");
            IMP imp = [obj methodForSelector:RefreshOtherInfo];
            void (*func)() = (void *)imp;
            func(obj, RefreshOtherInfo);
            *stop = YES;
        }
    }];
    
    //页面消失时停止播放语音
    [audioCell mediaCellStopAudio];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.jlgDatePickerView = nil;
}

#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (self.yzgGetBillModel.accounts_type.code == 2)?2:1;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 && self.yzgGetBillModel.accounts_type.code == 2) {
        return 2;
    }
    
    return  1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    NSUInteger section = indexPath.section;
    YZGAudioAndPicTableViewCell *auidioPicCell = [YZGAudioAndPicTableViewCell cellWithTableView:tableView];
    switch (section) {
        case 0:{
            if (self.yzgGetBillModel.accounts_type.code == 2) {
                cell = [self configureNextVcCell:cell atIndexPath:indexPath];
            }else{
                [self configureAudioAndPicCell:auidioPicCell];
                auidioPicCell.tableView = tableView;
                cell = auidioPicCell;
            }
        }
            break;
        case 1:{
            [self configureAudioAndPicCell:auidioPicCell];
            auidioPicCell.tableView = tableView;
            cell = auidioPicCell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void )configureAudioAndPicCell:(YZGAudioAndPicTableViewCell *)auidioPicCell{
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    
    dataDic[@"notes_txt"] = self.yzgGetBillModel.notes_txt;
    dataDic[@"voice_length"] = [NSString stringWithFormat:@"%@",@(self.yzgGetBillModel.voice_length)];
    dataDic[@"notes_voice"] = self.yzgGetBillModel.notes_voice;
    dataDic[@"amrFilePath"] = self.yzgGetBillModel.notes_voice_amr;
    
    [auidioPicCell configureAudioAndPicCell:dataDic showVc:self imagesArray:self.imagesArray.mutableCopy];
}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.yzgGetBillModel) {
        return 0;
    }
    
    if (indexPath.section == 0) {
        if (self.yzgGetBillModel.accounts_type.code == 2) {
            return kNormalCellHeight;
        }else{
            YZGAudioAndPicTableViewCell *auidioPicCell = [YZGAudioAndPicTableViewCell cellWithTableView:tableView];
            
            CGFloat newHeight = [auidioPicCell getiAudioHeight:self.yzgGetBillModel textViewHeight:self.cellTextViewHeight];
            return newHeight - 63;
        }
    }
    
    return kAudioCellHeight - 113;
}

#pragma mark - 点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.yzgGetBillModel.accounts_type.code != 2) {
        return;
    }
    
    if (indexPath.section == 1) {
        return;
    }
    
    if (indexPath.row == 1 &&([self.yzgGetBillModel.start_time isEqualToString:@"0"]||[NSString isEmpty:self.yzgGetBillModel.start_time])) {
        [TYShowMessage showPlaint:@"请选择开工时间"];
        return;
    }
    
    [self.tableView endEditing:YES];
    NSString *dateString = indexPath.row == 0?self.yzgGetBillModel.start_time:self.yzgGetBillModel.end_time;
    
    BOOL dateStringIsNotExist = [dateString isEqualToString:@"0"]||[NSString isEmpty:dateString];
    
    self.jlgDatePickerView.datePicker.date = dateStringIsNotExist?[NSDate date]:[NSDate dateFromString:dateString withDateFormat:@"yyyyMMdd"];
    [self.jlgDatePickerView showDatePickerByIndexPath:indexPath];
}

#pragma mark - 配置cell
- (YZGRecordWorkNextVcTableViewCell *)configureNextVcCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    YZGRecordWorkNextVcTableViewCell *nextVcCell= [YZGRecordWorkNextVcTableViewCell cellWithTableView:self.tableView];
    NSString *detailString;
    
    NSString *titleStrDefault = self.cellDataArray[indexPath.row][0];
    NSString *detailStrDefault = self.cellDataArray[indexPath.row][1];

    switch (indexPath.row) {
        case 0:
        {
            detailString = self.yzgGetBillModel.start_timeString;
        }
            break;
        case 1:
        {
            detailString = self.yzgGetBillModel.end_timeString;
        }
            break;
        default:
            break;
    }
    
    [nextVcCell setDetailTFPlaceholder:detailStrDefault];
    [nextVcCell setTitleColor:nil setDetailColor:[UIColor blackColor]];
    [nextVcCell setTitle:titleStrDefault setDetail:[NSString isEmpty:detailString]?nil:detailString];
    
    return nextVcCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= 4) {
        [TYShowMessage showPlaint:@"最多可以上传4张图片"];
        return ;
    }
    
    self.imageSelectedIndex = indexPath.row;
    [self pushPhotoBroswerWithStyle:LGShowImageTypeImageURL];
}

#pragma mark - AudioAndPicCell的delegate
#pragma mark 删除图片
- (void)AudioAndPicCellDelete:(YZGAudioAndPicTableViewCell *)cell Index:(NSInteger )index{
    if ([self.imagesArray[index] isKindOfClass:[NSString class]]) {//记录删除的图片地址
        [self.deleteImgsArray addObject:self.imagesArray[index]];
    }
    //更新数据源
    [self removeImageAtIndex:index];
}

#pragma mark 编辑结束时也要获取备注信息
- (void)AudioAndPicCellTextFiledEndEditing:(YZGAudioAndPicTableViewCell *)cell textStr:(NSString *)textStr{
    self.yzgGetBillModel.notes_txt = textStr;
}

- (void)AudioAndPicCellTextViewDidChange:(UITextView *)textView textViewHeight:(CGFloat )textViewHeight{
    self.yzgGetBillModel.notes_txt = textView.text;
    self.cellTextViewHeight = textViewHeight;
}
#pragma mark 添加图片
- (void)AudioAndPicAddPicBtnClick:(YZGAudioAndPicTableViewCell *)cell{
    [self.view endEditing:YES];
    [self.sheet showInView:self.view];
}

#pragma mark 成功添加录音
- (void)AudioAndPicAddAudio:(YZGAudioAndPicTableViewCell *)cell audioInfo:(NSDictionary *)audioInfo{
    if (audioInfo.allKeys.count == 0) {
        return ;
    }
    
    NSInteger fileTime = [audioInfo[@"fileTime"] integerValue];
    if (fileTime == 0) {
        self.yzgGetBillModel.notes_voice = nil;
        self.yzgGetBillModel.notes_voice_amr = nil;
        self.yzgGetBillModel.voice_length = 0;
    }else{
        self.yzgGetBillModel.notes_voice = audioInfo[@"filePath"];
        self.yzgGetBillModel.notes_voice_amr = audioInfo[@"amrFilePath"];
        self.yzgGetBillModel.voice_length = fileTime;
    }
}

#pragma mark - 选择完时间
- (void)JLGDatePickerSelect:(NSDate *)date byIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
       /* NSDate *currentDate = [NSDate date];//获取当前时间，日期
        if (([currentDate compare:date] == NSOrderedDescending)||([currentDate compare:date] ==NSOrderedSame )) {
            [TYShowMessage showPlaint:@"所选时间必须大于开工时间"];
            self.yzgGetBillModel.start_time = [NSDate stringFromDate:currentDate format:@"yyyyMMdd"];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];


            return;
  
        }*/
        if (self.yzgGetBillModel.end_time) {
            NSString *str =[NSDate stringFromDate:date format:@"yyyyMMdd"];
            if ([str compare:self.yzgGetBillModel.end_time] ==  NSOrderedDescending) {
                [TYShowMessage showPlaint:@"所选时间必须大于开工时间"];
                return;
            }
        }
        self.yzgGetBillModel.start_time = [NSDate stringFromDate:date format:@"yyyyMMdd"];
    }else if(indexPath.row == 1){
        if ([date compare:self.yzgGetBillModel.startDate] == NSOrderedAscending) {
            [TYShowMessage showPlaint:@"所选时间必须大于开工时间"];
            return;
        }
        self.yzgGetBillModel.end_time = [NSDate stringFromDate:date format:@"yyyyMMdd"];
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 增加完图片
- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr{
    //刷新
    if (self.yzgGetBillModel.accounts_type.code == 2) {//包工
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:1],nil] withRowAnimation:UITableViewRowAnimationNone];
    }else{//点工，借支
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - 懒加载
- (JLGDatePickerView *)jlgDatePickerView
{
    if (!_jlgDatePickerView) {
        _jlgDatePickerView = [[JLGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgDatePickerView.delegate = self;
        [_jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:@"2099-12-31"];
    }
    return _jlgDatePickerView;
}

#pragma mark - 懒加载
- (NSArray *)cellDataArray
{
    if (!_cellDataArray) {
        if (self.yzgGetBillModel.accounts_type.code == 2) {
            _cellDataArray = @[
                                   @[@"选择开工时间",@"请选择开工时间"],
                                   @[@"选择完工时间",@"请选择完工时间"]
                               ];
        }
    }
    
    return _cellDataArray;
}
@end

//
//  JGJMarkBillRemarkViewController.m
//  mix
//
//  Created by Tony on 2018/1/29.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMarkBillRemarkViewController.h"

#import "JGJPoorBillPhotoTableViewCell.h"

#import "JGJLableSize.h"

#import "JGJMarkBillModifyRemarkTableViewCell.h"

#import "JGJMarkBillContractTimeTableViewCell.h"

#import "JGJRemarkModifyBillsTableViewCell.h"

#import "JLGDatePickerView.h"

#import "NSDate+Extend.h"

#import "JGJMarkBillViewController.h"

#import "UIPhotoViewController.h"
@interface JGJMarkBillRemarkViewController ()
<
UITableViewDataSource,

UITableViewDelegate,

JLGDatePickerViewDelegate,

PoorBillPhotoTableViewCelldelegate,

UIActionSheetDelegate,

JGJRemarkModifyBillsTableViewCellDelegate,

UIImagePickerControllerDelegate
>
{
    JGJPoorBillPhotoTableViewCell *photoImageCell;
    
    NSString *_remarkTxt;
}
@property (strong ,nonatomic)NSArray *dataArr;

@property (strong ,nonatomic)NSArray *subDataArr;

@property (strong ,nonatomic)JLGDatePickerView *jlgDatePickerView;

@end

@implementation JGJMarkBillRemarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.title = @"备注信息";
    self.tableView.backgroundColor = AppFontf1f1f1Color;
    
    [self setLeftBatButtonItem];

}

- (void)setLeftBatButtonItem {
    
    SEL getLeftButton = NSSelectorFromString(@"getLeftNoTargetButton");
    IMP imp = [self.navigationController methodForSelector:getLeftButton];
    UIButton* (*func)(id, SEL) = (void *)imp;
    UIButton *leftButton = func(self.navigationController, getLeftButton);
    
    [leftButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
}

- (void)backButtonPressed {
    
    
    if ([self.markBillRemarkDelegate respondsToSelector:@selector(makeRemarkWithImages:text:)]) {

        [self.markBillRemarkDelegate makeRemarkWithImages:self.imagesArray text:self.yzgGetBillModel.notes_txt];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        
        cell = [self loadContractTimeFromIndexPath:indexPath];
        
    }else{
        if (indexPath.row == 0) {
            cell = [self loadContractTextfiledFromIndexPath:indexPath];
        }else{
            cell = [self loadContractImageFromIndexPath:indexPath];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
//开工时间和完工时间
- (JGJMarkBillContractTimeTableViewCell *)loadContractTimeFromIndexPath:(NSIndexPath *)indexPath
{
    JGJMarkBillContractTimeTableViewCell *cell = [JGJMarkBillContractTimeTableViewCell cellWithTableView:self.tableView];
   
    if (indexPath.row == 0) {
               cell.titleLable.text = @"选择开工时间";
        if ([NSString isEmpty: self.yzgGetBillModel.p_s_time ]) {
            cell.contentLable.textColor = AppFont999999Color;
            cell.contentLable.text = @"请选择开工时间";
        }else{
            cell.contentLable.text = [NSString stringDateFrom: self.yzgGetBillModel.p_s_time ];
            cell.contentLable.textColor = AppFont333333Color;
        }
    }else{
               cell.titleLable.text = @"选择完工时间";
        if ([NSString isEmpty: self.yzgGetBillModel.p_e_time ]) {
            cell.contentLable.textColor = AppFont999999Color;
     
            cell.contentLable.text = @"请选择完工时间";
        }else{
            cell.contentLable.text = [NSString stringDateFrom: self.yzgGetBillModel.p_e_time ];
            cell.contentLable.textColor = AppFont333333Color;
        }
    }

    return cell;
}
//编辑输入框
- (JGJRemarkModifyBillsTableViewCell *)loadContractTextfiledFromIndexPath:(NSIndexPath *)indexPath
{
    JGJRemarkModifyBillsTableViewCell *cell = [JGJRemarkModifyBillsTableViewCell cellWithTableView:self.tableView];
    cell.delegate = self;
    if ([NSString isEmpty: self.yzgGetBillModel.notes_txt]) {
        
        cell.placeLable.text = self.subDataArr[indexPath.section][indexPath.row];
        cell.placeLable.hidden = NO;
    }else{
        cell.placeLable.hidden = YES;
        cell.textView.text = self.yzgGetBillModel.notes_txt;
        cell.textView.textColor = AppFont333333Color;
    }
    cell.lineLable.hidden = YES;
    cell.placeLable.text = @"此处请填写备注，也可以用下面照片记录";
    cell.headImageView.hidden = YES;
    cell.leftImageViewConstance.constant = -23;
    cell.topDepartConstance.constant = 15;
    cell.topRightConstance.constant = 15;
    cell.textviewLeftConstance.constant = 15;
    cell.textViewPlaceConstance.constant = 18;

    return cell;
}
//图片编辑

- (JGJPoorBillPhotoTableViewCell *)loadContractImageFromIndexPath:(NSIndexPath *)indexPath
{
    photoImageCell = [JGJPoorBillPhotoTableViewCell cellWithTableView:self.tableView];
    
    photoImageCell.delegate = self;
    
    photoImageCell.imageArr = self.imagesArray;
    
    return photoImageCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }else{
        if (indexPath.row == 0) {
            
            return 140;
        }else{
            
            return (TYGetUIScreenWidth - 50)/4 + 20;
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.remarkBillType == JGJRemarkBillOtherType) {
            return 0;
        }else{
            return 2;
        }
    }

    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.section == 0) {
        NSString *dateString = indexPath.row == 0?self.yzgGetBillModel.p_s_time:self.yzgGetBillModel.p_e_time;
        BOOL dateStringIsNotExist = [dateString isEqualToString:@"0"]||[NSString isEmpty:dateString];
        if (![NSString isEmpty:dateString]) {
            if (dateString.length < 8) {
                dateStringIsNotExist = YES;
            }
        }
        self.jlgDatePickerView.datePicker.date = dateStringIsNotExist?[NSDate date]:[NSDate dateFromString:dateString withDateFormat:@"yyyyMMdd"];
        [self.jlgDatePickerView showDatePickerByIndexPath:indexPath];
    }
    
}
- (JLGDatePickerView *)jlgDatePickerView
{
    if (!_jlgDatePickerView) {
        _jlgDatePickerView = [[JLGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgDatePickerView.delegate = self;
        //显示记更多天按钮
        [_jlgDatePickerView setDatePickerMinDate:@"2014-01-01" maxDate:@"2099-12-31"];
    }
    return _jlgDatePickerView;
}
//选择时间
- (void)JLGDatePickerSelect:(NSDate *)date byIndexPath:(NSIndexPath *)indexPath{
    
    NSString *dateCurrentStr =[NSDate stringFromDate:date format:@"yyyyMMdd"];
    
    if (indexPath.row == 0) {
        if (![NSString isEmpty:self.yzgGetBillModel.p_e_time]) {
            if ([dateCurrentStr compare:self.yzgGetBillModel.p_e_time] ==    NSOrderedDescending) {
                [TYShowMessage showPlaint:@"所选时间必须大于开工时间"];
                return;
            }
        }
    }else if(indexPath.row == 1){
        if ([dateCurrentStr compare:self.yzgGetBillModel.p_s_time] == NSOrderedAscending) {
            [TYShowMessage showPlaint:@"所选时间必须大于开工时间"];
            return;
        }
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    if (indexPath.row == 0) {
        self.yzgGetBillModel.p_s_time = dateStr;
    }else{
        self.yzgGetBillModel.p_e_time = dateStr;
        
    }
    [self.tableView reloadData];
}

-(void)RemarkModifyBillsTextfiledEting:(NSString *)text
{
    _remarkTxt = text;
    self.yzgGetBillModel.notes_txt = text;
    if (self.yzgGetBillModel.notes_txt.length == 0) {
        
        [self.tableView reloadData];
    }
}

#pragma mark - 添加玩图片
- (void)phoneVc:(UIPhotoViewController *)phoneVc imagesArrayAddEnd:(NSArray *)imagesArr
{
    for (int index = 0; index < imagesArr.count; index ++) {
        if ([self.imagesArray containsObject:imagesArr[index]]) {
            [self.imagesArray removeObject:imagesArr[index]];
            
        }
    }
    if (self.imagesArray.count + imagesArr.count > 4) {
        [TYShowMessage showPlaint:@"最多上传四张图片"];
        return;
    }
    
    for (int index = 0; index < imagesArr.count; index ++) {
        if (![self.imagesArray containsObject:imagesArr[index]]) {
            [self.imagesArray addObject:imagesArr[index]];

        }
    }
    
    [self.tableView reloadData];
    
}
-(void)ClickPoorBillPhotoBtn
{
    [self.view endEditing:YES];
    [self.sheet showInView:self.view];
    
}
- (void)initSheetImagePicker{
    //不使用懒加载，主要先初始化，避免速度慢
    if (!self.sheet) {
        //设置拍照的点击
        self.sheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
    }
    
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
    }
}
//删除图片
-(void)deleteImageAndImageArr:(NSMutableArray *)imageArr andDeletedIndex:(NSInteger)index
{
    [self.imagesArray removeObjectAtIndex:index];
    [self.tableView reloadData];

}
- (void)viewWillDisappear:(BOOL)animated
{

    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(@"JGJMarkBillViewController")]) {
//            JGJMarkBillViewController *recordVc = (JGJMarkBillViewController *)vc;
//            recordVc.remarkYzgGetBillModel = self.yzgGetBillModel;
//            recordVc.imagesArray = self.imagesArray;
            break;
        }
        
    }
}


@end

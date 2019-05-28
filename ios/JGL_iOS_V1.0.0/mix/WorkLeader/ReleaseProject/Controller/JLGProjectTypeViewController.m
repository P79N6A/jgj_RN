//
//  JLGJobTypeViewController.m
//  mix
//
//  Created by jizhi on 15/11/20.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGProjectTypeViewController.h"

#import "TYFMDB.h"
#import "TYBaseTool.h"
#import "TYShowMessage.h"
#import "JLGJobTypeTableViewCell.h"
#import "UITableViewCell+Extend.h"

@interface JLGProjectTypeViewController ()
{
    NSInteger _selectNum;
    NSInteger _selectTotalNum;
    NSArray *_oldSelectedArray;
}

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

//constrint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewLayoutH;
@end

@implementation JLGProjectTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    if (self.selectedSingle ) {
        _selectNum = 0;
        for (NSInteger i = 0; i < self.projectTypesArray.count; i++) {
            if ([self.selectedArray[i] integerValue] == YES) {
                _selectNum = i;
                break;
            }
        }
        
        self.topLabel.text = nil;
        self.topViewLayoutH.constant /= 2;
    }else{//计算一共选择了多少个
        _selectTotalNum = 0;
        
        if (!self.selectedArray) {
            self.selectedArray = [NSMutableArray array];
            for (NSInteger idx = 0; idx < self.projectTypesArray.count; idx++) {
                [self.selectedArray addObject:@NO];
            }
        }else{
            for (NSInteger i = 0; i < self.projectTypesArray.count; i++) {
                if ([self.selectedArray[i] integerValue] == YES) {
                    _selectTotalNum++;
                }
            }
        }

        if (self.multipleNoLimit) {//多选没有限制
            self.topLabel.text = @"可多选";
        }else{//多选有限制
            [self setSelectNumLabelSelectByNum:_selectTotalNum];
        }
    }
    
    [self.confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    if (!CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, JGJMainColor.CGColor)) {
        SEL selector = NSSelectorFromString(@"getWhiteLeftNoTargetButton");
        IMP imp = [self.navigationController methodForSelector:selector];
        UIButton *(*func)(id, SEL) = (void *)imp;
        if (func) {
            UIButton *whiteLeftNoTargetButton = func(self.navigationController, selector);
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:whiteLeftNoTargetButton];
            [whiteLeftNoTargetButton addTarget:self action:@selector(cancelButtonDown:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:JGJMainColor tintColor:JGJMainColor titleColor:[UIColor whiteColor]];
    }
    
    //保存初始值
    _oldSelectedArray = [self.selectedArray copy];
    
//    通用设置
    [self commonSet];
}


- (void)commonSet {

    switch (self.selectedType) {
        case ProjectType: {
            self.title = @"选择工程类别";
        }
            break;
        case WorkType: {
            self.title = @"所需工种";
        }
            break;
            case Work_level:
            self.title = @"选择熟练度";
            break;
        default:
            break;
    }
}

- (void)cancelButtonDown:(UIButton *)button{
    //还原
    self.selectedArray = [_oldSelectedArray mutableCopy];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //显示成红色
    if (!CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, JGJMainColor.CGColor)) {
        SEL selector = NSSelectorFromString(@"getWhiteLeftBarButton");
        IMP imp = [self.navigationController methodForSelector:selector];
        UIBarButtonItem *(*func)(id, SEL) = (void *)imp;
        if (func) {
            UIBarButtonItem *whiteLeftBarButton = func(self.navigationController, selector);
            self.navigationItem.leftBarButtonItem = whiteLeftBarButton;
        }
        
        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:JGJMainColor tintColor:[UIColor whiteColor] titleColor:[UIColor whiteColor]];
    }
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (!CGColorEqualToColor(self.navigationController.navigationBar.barTintColor.CGColor, AppFontfafafaColor.CGColor)) {
        SEL selector = NSSelectorFromString(@"getLeftBarButton");
        IMP imp = [self.navigationController methodForSelector:selector];
        UIBarButtonItem *(*func)(id, SEL) = (void *)imp;
        if (func) {
            UIBarButtonItem *leftBarButtonItem = func(self.navigationController, selector);
            self.navigationItem.leftBarButtonItem = leftBarButtonItem;
        }
        
        [TYBaseTool setupNavByNarBar:self.navigationController.navigationBar BybarTintColor:AppFontfafafaColor tintColor:JGJMainRedColor titleColor:AppFont333333Color];
    }
}

- (void)setSelectNumLabelSelectByNum:(NSInteger )selectedNum{
    NSString *title = (self.selectedType == ProjectType) ? @"类别 ": @"工种";
    
//    NSString *baseStr = [NSString stringWithFormat:@"你最多可选择5个%@(还剩下", title];
//    NSString *selectedStr = [NSString stringWithFormat:@"%@个)",@(5 - selectedNum)];

    NSString *baseStr = [NSString stringWithFormat:@"你最多可选择%d个%@(还剩下",(self.selectedType == ProjectType) ? 3: 5,title];
    NSString *selectedStr;
    if (self.selectedType == ProjectType) {
    selectedStr = [NSString stringWithFormat:@"%@个)",@( 3 - selectedNum)];
    }else if (self.selectedType == WorkType){
    selectedStr = [NSString stringWithFormat:@"%@个)",@( 5 - selectedNum)];
    }
    NSString *finalStr = [NSString stringWithFormat:@"%@%@",baseStr,selectedStr];
    NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc] initWithString:finalStr];
    
    //数字需要黄色
    [contentStr addAttribute:NSForegroundColorAttributeName value:TYColorHex(0xf8a43f) range:NSMakeRange(baseStr.length, selectedStr.length-2)];
    
    self.topLabel.attributedText = contentStr;
}

#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projectTypesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JLGJobTypeTableViewCell *cell = [JLGJobTypeTableViewCell cellWithTableView:tableView];
    cell.tag = indexPath.row;

    BOOL isSelected = [self.selectedArray[indexPath.row] integerValue] == 1;
    
    if (self.selectedSingle) {
//      [cell setChangeSingleStatus:isSelected];
        [cell setChangeSingleStatus:NO];

    }else {
        [cell setChangeStatus:isSelected];
    }

    cell.titleLabel.text = self.projectTypesArray[indexPath.row][@"name"];
    
    return cell;
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.selectedSingle) {
        
//        if ([self.selectedArray[indexPath.row] boolValue] == 1) {
//            return;
//        }
        
        for (NSInteger idx = 0; idx < self.selectedArray.count; idx++) {
            self.selectedArray[idx] = (indexPath.row == idx)?@1:@0;
        }
        
        _selectNum = indexPath.row;
        [self.tableView reloadData];
        [self tapSkill];
        
    }else{
        if (!self.multipleNoLimit) {//多选有限制
            if (self.selectedType == ProjectType) {
                
                if (_selectTotalNum == 3 && ![self.selectedArray[indexPath.row] boolValue]) {
                    [TYShowMessage showPlaint:@"最多只能选择三种类型"];
                    return;
                }
  
            }else if (self.selectedType == WorkType){
            if (_selectTotalNum == 5 && ![self.selectedArray[indexPath.row] boolValue]) {
                [TYShowMessage showPlaint:@"最多只能选择五种类型"];
                return;
            }
            }
        }
        
        self.selectedArray[indexPath.row] = @(![self.selectedArray[indexPath.row] boolValue]);
        
        _selectTotalNum = 0;
        for (NSInteger idx = 0; idx < self.selectedArray.count; idx++) {
            if ([self.selectedArray[idx] integerValue] == YES) {
                _selectTotalNum++;
            }
        }
        
        if (self.multipleNoLimit) {//多选没有限制
            self.topLabel.text = @"可多选";
        }else{//多选有限制
            [self setSelectNumLabelSelectByNum:_selectTotalNum];
        }
        
        JLGJobTypeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        BOOL isSelected = [self.selectedArray[indexPath.row] integerValue] == 1; 
        [cell setChangeStatus:isSelected];
    }
}


#pragma mark - 熟练度单选就反回

- (IBAction)confirmBtnClick:(id)sender {
    __block NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    if (self.selectedSingle) {
        [dataArray  addObject:self.projectTypesArray[_selectNum]];
        dataDic[@"id"] = [dataArray firstObject][@"id"];
        dataDic[@"name"] = [dataArray firstObject][@"name"];
    }else{
        [self.selectedArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj boolValue]) {
                [dataArray  addObject:self.projectTypesArray[idx]];
            }
        }];
        
        NSMutableArray *projectTypesIdArray = [NSMutableArray array];
        NSMutableArray *projectTypesNameArray = [NSMutableArray array];
        
        for (NSInteger i = 0 ; i < dataArray.count; i++) {
            [projectTypesIdArray addObject:dataArray[i][@"id"]];
            [projectTypesNameArray addObject:dataArray[i][@"name"]];
        }
        dataDic[@"id"] = [projectTypesIdArray componentsJoinedByString:@","];
        dataDic[@"name"] = [projectTypesNameArray componentsJoinedByString:@","];
    }
    

    if ([self.delegate respondsToSelector:@selector(JLGProjectTypeVc:SelectedArray:dataDic:)]) {
        [self.delegate JLGProjectTypeVc:self SelectedArray:self.selectedArray dataDic:[dataDic copy]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tapSkill
{
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    [dataArray  addObject:self.projectTypesArray[_selectNum]];
    dataDic[@"id"] = [dataArray firstObject][@"id"];
    dataDic[@"name"] = [dataArray firstObject][@"name"];
    
    if ([self.delegate respondsToSelector:@selector(JLGProjectTypeVc:SelectedArray:dataDic:)]) {
        [self.delegate JLGProjectTypeVc:self SelectedArray:self.selectedArray dataDic:[dataDic copy]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end

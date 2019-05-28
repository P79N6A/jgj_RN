//
//  JGJMarkBillBottomBaseView.m
//  mix
//
//  Created by Tony on 2018/1/8.
//  Copyright © 2018年 JiZhi. All rights reserved.
//

#import "JGJMarkBillBottomBaseView.h"

#import "JGJMainRemaingTableViewCell.h"

#import "JGJMainYearDetailTableViewCell.h"

#import "JGJMainMarkBillTableViewCell.h"
@interface JGJMarkBillBottomBaseView ()
<
UITableViewDelegate,

UITableViewDataSource
>
@property (strong, nonatomic)NSArray *titleArr;

@property (strong, nonatomic)NSArray *imageArr;

@end
@implementation JGJMarkBillBottomBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self loadView];
    }
    return self;
}

- (void)loadView{
    
    UIView *contentView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]firstObject];
    
    [contentView setFrame:self.bounds];
    
    self.tableView.delegate = self;
    
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView .bounces = NO;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self addSubview:contentView];

    
}
- (void)setModel:(JGJRecordMonthBillModel *)model{
    
    if (!_model) {
        
        _model = [[JGJRecordMonthBillModel alloc]init];
    }
    _model = model;
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        JGJMainRemaingTableViewCell *cell = [JGJMainRemaingTableViewCell cellWithTableView:tableView];
        cell.titleLable.text = self.titleArr[indexPath.section];
        cell.model = self.model;
        return cell;
        
    }else if (indexPath.section == 1){
        
        JGJMainMarkBillTableViewCell *cell = [JGJMainMarkBillTableViewCell cellWithTableView:tableView];
        
        cell.titleLable.text = _titleArr[indexPath.section];
        
        cell.headerImageView.image = [UIImage imageNamed:_imageArr[indexPath.section]];
        
        return cell;
   
    }else{

        JGJMainMarkBillTableViewCell *cell = [JGJMainMarkBillTableViewCell cellWithTableView:tableView];
        
        cell.titleLable.text = _titleArr[indexPath.section];
        
        cell.headerImageView.image = [UIImage imageNamed:_imageArr[indexPath.section]];
        
        if (indexPath.section == 4) {
            
            cell.leftPaddinng.constant = 44;
        }
        if (indexPath.section == 4) {
            
            cell.line1.hidden = NO;
        }else {
            
            cell.line1.hidden = YES;
        }
        
        if (indexPath.section == 5) {
            
            cell.line2.hidden = NO;
            cell.line3.hidden = NO;
            
        }else {
            
            cell.line2.hidden = YES;
            cell.line3.hidden = YES;
        }
        
        return cell;

    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!_isLeder) {
        
        return 4;
    }
    return 6;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 10)];
    view.backgroundColor = AppFontf1f1f1Color;
    UIView *upLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, 0.5)];
    upLine.backgroundColor = AppFontdbdbdbColor;
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 9.5, TYGetUIScreenWidth, 0.5)];
    downLine.backgroundColor = AppFontdbdbdbColor;
    [view addSubview:upLine];
    [view addSubview:downLine];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 1 || section == 2 || section == 4) {
        
        return 10;
    }
    
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return 55;
    }
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        
//        self.didSelectMarkBillBlock(JGJRemaingAmountType);
//        
//    }
//    // 班组长或工人管理
//    else if (indexPath.section == 1){
//       
//        if (!_isLeder) {
//            
//            self.didSelectMarkBillBlock(JGJMarkBillJobForemanType);
//
//        }else{
//            
//        
//            self.didSelectMarkBillBlock(JGJMarkBillWorkerManagement);
//
//        }
//        
//    }else if (indexPath.section == 2){
//
//        self.didSelectMarkBillBlock(JGJMarkBillWaterType);
//    }else if (indexPath.section == 3){
//
//        self.didSelectMarkBillBlock(JGJMarkBillTotalType);
//        
//    }else if (indexPath.section == 4 && !_isLeder){
//        
//        self.didSelectMarkBillBlock(JGJMarkBillFrequentlyQuestionsType);
//        
//    }else if (indexPath.section == 4 && _isLeder){
//        
//        self.didSelectMarkBillBlock(JGJMarkBillSynchronizationType);
//        
//    }else if (indexPath.section == 5 && _isLeder){
//        
//        self.didSelectMarkBillBlock(JGJMarkBillSynchronizationTypeToMe);
//        
//    }

}
@end


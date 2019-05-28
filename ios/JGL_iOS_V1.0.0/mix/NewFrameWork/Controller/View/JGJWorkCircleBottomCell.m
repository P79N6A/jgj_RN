//
//  JGJWorkCircleBottomCell.m
//  mix
//
//  Created by yj on 16/8/16.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "JGJWorkCircleBottomCell.h"
#import "JGJWorkCircleProGroupCell.h"
#import "JGJWorkCircleDefaultProGroupCell.h"
#import "JGJCustomLable.h"
#import "UIView+GNUtil.h"
#import "NSString+Extend.h"
#import "UILabel+GNUtil.h"
#import "JGJWorkCircleMiddleTableViewCell.h"

#import "JGJHomeProCell.h"

#import "JGJCusHeaderView.h"

#import "JGJCusFooterView.h"

#import "JGJLoadStatusViewCell.h"

#define BottomCellMargin 10

typedef enum : NSUInteger {
    JGJWorkCircleDefaultProGroupCellType,
    JGJWorkCircleDefaultSweepQrcodeCellType
    
} JGJWorkCircleDefaultCellType;

@interface JGJWorkCircleBottomCell () <
UITableViewDelegate,
UITableViewDataSource,
WorkCircleDefaultDelegate,
SWTableViewCellDelegate,
JGJWorkCircleProTypeTableViewCellDelegate,
JGJWorkCircleMiddleTableViewCellDelegate,
JGJCheckAccountModulesViewDelegate,
JGJLoadStatusViewCellDelegate
>
@property (strong, nonatomic) UIView *tableViewFooterView;

@property (strong, nonatomic) JGJWorkCircleHeaderView *workCircleHeaderView ;
@property (strong, nonatomic) UIView *footView;
@property (strong, nonatomic) JGJCustomLable *shutGroupLable;
@property (strong ,nonatomic) CALayer *unProDefaultProsublayer; //没有项目底部阴影
@property (strong ,nonatomic) CALayer *bottomsublayer; //底部整体阴影
@property (strong ,nonatomic) CALayer *knowBasesublayer; //知识库两边的阴影
@end

@implementation JGJWorkCircleBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    //按钮高亮取消响应延时
//    self.workCircleTableView.delaysContentTouches = NO;
        
    self.workCircleTableView.backgroundColor = AppFontf1f1f1Color;
    
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    [self.workCircleTableView.layer setLayerCornerRadius:JGJCornerRadius];
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"Cell";
    JGJWorkCircleBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JGJWorkCircleBottomCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setProListModel:(JGJMyWorkCircleProListModel *)proListModel {

    _proListModel = proListModel;
    
    //有项目设置成功
    
    if (!self.proListModel.isUnProInfo) {
        
        [TYUserDefaults setInteger:3 forKey:JGJHomeLoadStatusKey];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //没有项目的时候两段，有项目的时候一段
    
    return self.proListModel.isUnProInfo ? 3 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (section == 0) {
        
        //工头第一段两个记账按钮和班组加人，工人去掉班组加人
        
        if (self.proListModel.isUnProInfo) {
            
            count = 1;
            
        }else {
            
            count = 2;
        }
        
    }else if (section == 1 || section == 2) {
        
        count = 1;
        
    }
    
    return count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0.0;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            //记账按钮
            
            height = WorkCircleFirstCellHeight;
            
        }else {
            
            height = [self existProTableView:tableView heightForRowAtIndexPath:indexPath];
        }
        
    }else if (indexPath.section == 1 || indexPath.section == 2) {
        
        //雇佣招工项目高度
        
        height = [self unProEmployInfoWithTableView:tableView heightForRowAtIndexPath:indexPath];
    }

    return height;
}

- (CGFloat)UnProTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    

    return JGJHomeUnProHeight;
    
}

- (CGFloat)unProEmployInfoWithTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    CGFloat height = 175.0;
    switch (indexPath.section) {
        case 1:{
            
            height = [JGJCheckAccountModulesCell checkAccountModulesCellHeight];
        }
            
            break;
            
        case 2:{
            
            height = [JGJWorkCircleDefaultProGroupCell defaultCreatProCellHeight];
        }
            
            break;
            
        default:
            break;
    }
    
    return height;
}

- (CGFloat)existProTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = WorkCircleFirstCellHeight;
    
    if (indexPath.row == 0) {
        
        height = WorkCircleFirstCellHeight + self.bannerHeight.constant;
    }
    
    if (indexPath.row == 1) {
        
        height = [self.proListModel.group_info.class_type isEqualToString:@"group"] ? JGJHomeGroupHeight : JGJHomeProHeight;
        
    }
    
    return height;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    
    if (self.proListModel.isUnProInfo) {
        
         cell = [self handleRegisterUnProTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }else {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                cell = [self registerHomeAccountCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
                
            }else {
                
                cell = [self handleRegisterExistProTableView:tableView cellForRowAtIndexPath:indexPath];
            }
            
        }
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, BottomCellMargin)];
    
    header.backgroundColor = AppFontf1f1f1Color;
    
    return section == 2 || section == 1 ? header : nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    CGFloat height = section == 2 ? BottomCellMargin : CGFLOAT_MIN;
    
    if (section == 1) {
        
        height = 5.0;
    }
    
    return  height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {


    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return CGFLOAT_MIN;
}

- (UITableViewCell *)handleRegisterExistProTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJWorkCircleProTypeTableViewCell *proTypeCell = [JGJWorkCircleProTypeTableViewCell cellWithTableView:tableView];
    
    proTypeCell.proListModel = self.proListModel;
    
    proTypeCell.delegate = self;
    
    return proTypeCell;
    
}

- (UITableViewCell *)handleRegisterUnProTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;

    switch (indexPath.section) {
        case 0:{
            
             cell = [self registerHomeAccountCellWithTableView:tableView cellForRowAtIndexPath:indexPath];
            
        }
            
            break;
            
        case 1:{
            
            NSInteger status = JGJHomeLoadStatus;
            
            //1加载中，2记载失败
            
            if (status == 1 || status == 2) {
                
                JGJLoadStatusViewCell *statuscell = [JGJLoadStatusViewCell cellWithTableView:tableView];
                
                statuscell.status = status;
                                
                statuscell.delegate = self;
                
                cell = statuscell;
                
            }else {
                
                JGJCheckAccountModulesCell *checkAccountModulesCell = [JGJCheckAccountModulesCell cellWithTableView:tableView];
                
                checkAccountModulesCell.modulesView.delegate = self;
                
                checkAccountModulesCell.modulesView.recordTotalModel = self.recordTotalModel;
                
                cell = checkAccountModulesCell;
            }
            
        }
            break;
            
        case 2:{
            
            JGJWorkCircleDefaultProGroupCell *defaultProGroupCell = [JGJWorkCircleDefaultProGroupCell cellWithTableView:tableView];
            
            defaultProGroupCell.delegate = self;
            
            cell = defaultProGroupCell;
            
        }
            break;
            
        default:
            break;
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 1 && [self.delegate respondsToSelector:@selector(handleJGJJGJWorkCircleBottomCellDidSelected:)] && !self.proListModel.isUnProInfo) {
            
            [self.delegate handleJGJJGJWorkCircleBottomCellDidSelected:self.proListModel.group_info];
        }
        
    }
    
}

#pragma mark - buttonAction
#pragma mark - 头部按钮按下
- (void)tableViewHeaderButtonPressed:(WorkCircleHeaderFooterViewButtonType) buttonType {
    if (self.workCircleHeaderFooterViewBlock) {
        self.workCircleHeaderFooterViewBlock(buttonType);
    }
}

#pragma mark - 点击扫码和创建班组
- (void)defaultGroupBtnClick:(JGJWorkCircleDefaultProGroupCell *)jgjWorkCircleDefaultProGroupCell clickType:(WorkCircleHeaderFooterViewButtonType )clickType {
    
    [self tableViewHeaderButtonPressed:clickType];
    
}

- (void)dealloc
{

}

- (void)JGJWorkCircleProTypeTableViewCell:(JGJWorkCircleProTypeTableViewCell *)cell didSelectedType:(JGJWorkCircleMiddleInfoModel *)infoModel {
    
    if ([self.delegate respondsToSelector:@selector(handleJGJWorkCircleBottomCell:didSelectedListType:)]){
        
        [self.delegate handleJGJWorkCircleBottomCell:self didSelectedListType:infoModel];
    }
}

- (void)WorkCircleMiddleTableViewCellType:(WorkCircleCollectionViewCellType)circleCollectionViewCellType infoModel:(JGJWorkCircleMiddleInfoModel *)infoModel {
    
    if ([self.delegate respondsToSelector:@selector(handleJGJWorkCircleBottomCell:infoModel:)]) {
        
        [self.delegate handleJGJWorkCircleBottomCell:self infoModel:infoModel];
    }

}

- (void)proTypeTableViewCell:(JGJWorkCircleProTypeTableViewCell *)cell buttonType:(ProTypeHeaderButtonType)buttonType {
    
    if ([self.delegate respondsToSelector:@selector(handleButtonPressedWithButtonType:)]) {
        
        [self.delegate handleButtonPressedWithButtonType:buttonType];
    }
    
}

- (UITableViewCell *)registerHomeAccountCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    JGJHomeAccountNoteCell *accountCell = [JGJHomeAccountNoteCell cellWithTableView:tableView];

    TYWeakSelf(self);

    accountCell.cellBlock = ^(JGJHomeAccountNoteCellButtonType buttonType) {
      
        if ([weakself.delegate respondsToSelector:@selector(handleHomeAccountNoteCell:buttonType:)]) {
            
            [weakself.delegate handleHomeAccountNoteCell:self buttonType:buttonType];
            
        }
    };

    return accountCell;

}

- (void)checkAccountModulesView:(JGJCheckAccountModulesView *)modulesView buttontype:(JGJCheckAccountModulesButtontype)buttonType {
    
    
    if ([self.delegate respondsToSelector:@selector(bottomCellWithModulesView:buttontype:)]) {
        
        [self.delegate bottomCellWithModulesView:modulesView buttontype:buttonType];
    }
    
}


+ (CGFloat)headerAndFooterHeight {
    
    CGFloat height = [JGJCusHeaderView cusHeaderViewHeight] + [JGJCusFooterView cusFooterViewHeight];
    
    return height;
}

+(CGFloat)defaultCellHeight {
    
    CGFloat height =  [JGJCheckAccountModulesCell checkAccountModulesCellHeight] + [JGJWorkCircleDefaultProGroupCell defaultCreatProCellHeight] + WorkCircleFirstCellHeight + 2 * BottomCellMargin;
    
    return height;
}

//备用后面可能会要
//- (UITableViewCell *)registerAccountCellWithTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    JGJWorkCircleTodayAccountCell *accountCell = [JGJWorkCircleTodayAccountCell cellWithTableView:tableView];
//
//    TYWeakSelf(self);
//
//    accountCell.todayAccountCellBlock = ^(TodayAccountCellButtonType buttonType){
//
//        if ([weakself.delegate respondsToSelector:@selector(handleJGJWorkCircleTodayAccountCellButtonPressed:)]) {
//
//            [weakself.delegate handleJGJWorkCircleTodayAccountCellButtonPressed:TodayAccountCellCheckRecordButtonType];
//        }
//
//    };
//
//    accountCell.yzgWorkDayModel = self.yzgWorkDayModel;
//
//    return accountCell;
//
//}

- (void)loadStatusViewCell:(JGJLoadStatusViewCell *)cell {
    
    if ([self.delegate respondsToSelector:@selector(loadStatus:)]) {
        
        [self.delegate loadStatus:cell.status];
        
    }
}

@end

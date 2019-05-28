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

typedef enum : NSUInteger {
    JGJWorkCircleDefaultProGroupCellType,
    JGJWorkCircleDefaultSweepQrcodeCellType

} JGJWorkCircleDefaultCellType;

@interface JGJWorkCircleBottomCell () <UITableViewDelegate, UITableViewDataSource, WorkCircleDefaultDelegate, SWTableViewCellDelegate,JGJWorkCircleProTypeTableViewCellDelegate,
JGJWorkCircleMiddleTableViewCellDelegate>
@property (strong, nonatomic) UIView *tableViewFooterView;
@property (strong, nonatomic) JGJWorkCircleHeaderView *workCircleHeaderView ;
@property (strong, nonatomic) UIView *footView;
@property (strong, nonatomic) JGJCustomLable *shutGroupLable;

@property (strong ,nonatomic) CALayer *unProDefaultProsublayer; //没有项目底部阴影
@property (strong ,nonatomic) CALayer *bottomsublayer; //底部整体阴影
@property (strong ,nonatomic) CALayer *knowBasesublayer; //知识库两边的阴影

@property (weak, nonatomic) IBOutlet UIImageView *senorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myCreatImageView;

@end

@implementation JGJWorkCircleBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.workCircleTableView.layer setLayerCornerRadius:5.0];
    self.contentView.backgroundColor = AppFontf1f1f1Color;
    
    CALayer *bottomsublayer = [CALayer layer];
    self.bottomsublayer = bottomsublayer;
    bottomsublayer.backgroundColor = AppFontf1f1f1Color.CGColor;
    bottomsublayer.shadowOffset = CGSizeMake(0, 3);
    bottomsublayer.shadowRadius = 2.0;
    bottomsublayer.shadowColor = TYColorHex(0xeb4e4e).CGColor;
    bottomsublayer.shadowOpacity = 0.2;
    bottomsublayer.frame = CGRectMake(12, 0, TYGetUIScreenWidth - 24 , JGJHomeProHeight - 10);
    bottomsublayer.cornerRadius = 6.0;
    [self.contentView.layer insertSublayer:bottomsublayer atIndex:0];
    
////    没有数据的是时候知识库两边阴影
//    CALayer *knowBasesublayer = [CALayer layer];
//    self.knowBasesublayer = knowBasesublayer;
//    knowBasesublayer.backgroundColor = AppFontf1f1f1Color.CGColor;
//    knowBasesublayer.shadowOffset = CGSizeMake(0, 3);
//    knowBasesublayer.shadowRadius = 3.0;
//    knowBasesublayer.shadowColor = TYColorHex(0xeb4e4e).CGColor;
//    knowBasesublayer.shadowOpacity = 0.1;
//    knowBasesublayer.frame = CGRectMake(12, 12, TYGetUIScreenWidth - 24 , 110);
//    knowBasesublayer.cornerRadius = 6.0;
//    [self.contentView.layer insertSublayer:knowBasesublayer atIndex:0];
    
    //没有数据的是时候新建项目阴影
    CALayer *unProDefaultProsublayer = [CALayer layer];
    self.unProDefaultProsublayer = unProDefaultProsublayer;
    unProDefaultProsublayer.backgroundColor = AppFontf1f1f1Color.CGColor;
    unProDefaultProsublayer.shadowOffset = CGSizeMake(0, 3);
    unProDefaultProsublayer.shadowRadius = 3.0;
    unProDefaultProsublayer.shadowColor = TYColorHex(0xeb4e4e).CGColor;
    unProDefaultProsublayer.shadowOpacity = 0.1;
    unProDefaultProsublayer.frame = CGRectMake(12, 12, TYGetUIScreenWidth - 24 , 123 * 2);
    unProDefaultProsublayer.cornerRadius = 6.0;
    [self.contentView.layer insertSublayer:unProDefaultProsublayer atIndex:0];
    
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
    
    if (!self.proListModel.isUnProInfo) {
        
        self.unProDefaultProsublayer.hidden = YES;
        
        //显示整体阴影
        self.bottomsublayer.hidden = NO;
    }else {
        
        //没有项目隐藏
        self.unProDefaultProsublayer.hidden = NO;
        
        //显示整体阴影
        self.bottomsublayer.hidden = YES;
    }
    
//    self.workCircleTableView.alpha = proListModel.group_info.isClosedTeamVc ? 0.6 : 1;
    
//    self.workCircleHeaderView.proListModel = proListModel;
    
    self.senorImageView.hidden = NO;
    
    self.myCreatImageView.hidden = NO;
    
    NSString *senorStr = @"senor_service_icon";
    
    NSString *myCreatStr = @"myCreat_Pro_icon";
    
    BOOL isSenor = [proListModel.group_info.is_senior isEqualToString:@"1"];
    
    BOOL isMyCreat = [proListModel.group_info.myself_group isEqualToString:@"1"];
    
    //强制设置成NO取消黄金标识，3.2.0
    
    isSenor = NO;
    
    if (isSenor && isMyCreat) {
        
        self.senorImageView.hidden = NO;
        
        self.myCreatImageView.hidden = NO;
        
        senorStr = @"senor_service_icon";
        
        myCreatStr = @"myCreat_Pro_icon";
        
    } else if (isSenor && !isMyCreat)  {
        
        senorStr = @"senor_service_icon";
        
        myCreatStr = @"myCreat_Pro_icon";
        
        self.senorImageView.hidden = NO;
        
        self.myCreatImageView.hidden = YES;
        
    }else if (!isSenor && isMyCreat)  {
        
        senorStr = @"myCreat_Pro_icon";
        
        myCreatStr = @"";
        
        self.senorImageView.hidden = NO;
        
        self.myCreatImageView.hidden = YES;
    }else {
        
        self.senorImageView.hidden = YES;
        
        self.myCreatImageView.hidden = YES;
    }
    
    self.senorImageView.image = [UIImage imageNamed:senorStr];
    
    self.myCreatImageView.image = [UIImage imageNamed:myCreatStr];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0.0;
    if (self.proListModel.isUnProInfo) {
        
        height = [self UnProTableView:tableView heightForRowAtIndexPath:indexPath];
        
    }else {
        
        height = [self existProTableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return height;
}

- (CGFloat)UnProTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return JGJHomeProHeight;
    
}

- (CGFloat)existProTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return JGJHomeProHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    //没有数据的情况
    if (self.proListModel.isUnProInfo) {
        
        cell = [self handleRegisterUnProTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }else {
        
        cell = [self handleRegisterExistProTableView:tableView cellForRowAtIndexPath:indexPath];
        
    }
    
    return cell;
}

- (UITableViewCell *)handleRegisterExistProTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        
        JGJWorkCircleProTypeTableViewCell *proTypeCell = [JGJWorkCircleProTypeTableViewCell cellWithTableView:tableView];
        proTypeCell.proListModel = self.proListModel;
        proTypeCell.delegate = self;
        cell = proTypeCell;
    }else {
        
        JGJWorkCircleProGroupCell *proGroupCell = [JGJWorkCircleProGroupCell cellWithTableView:tableView];
        proGroupCell.proListModel = self.proListModel.group_info;
        proGroupCell.delegate = self;
        proGroupCell.lineView.hidden = YES;
        cell = proGroupCell;
    }
    return cell;
    
}

- (UITableViewCell *)handleRegisterUnProTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    JGJWorkCircleDefaultProGroupCell *defaultProGroupCell = [JGJWorkCircleDefaultProGroupCell cellWithTableView:tableView];
    if (!defaultProGroupCell.delegate) {
        defaultProGroupCell.delegate = self;
    }
    
    return defaultProGroupCell;
        
}

#pragma mark - 处理显示置顶和取消
- (NSArray *)handleStickWithProListModel:(JGJMyWorkCircleProListModel *)proListModel {
    NSString *stickStr = proListModel.is_sticked ? @"取消置顶" : @"置顶";
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     AppFontC7C6CBColor title:stickStr];
    return rightUtilityButtons;
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}

- (void)swipeableTableViewCell:(JGJWorkCircleProGroupCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    [self handleStickedButtonPressedWithCell:cell ButtonType:ProGroupCellStickButtonType];
}
#pragma mark - 设置滑动的偏移量
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [cell rightUtilityButtonsWidth]) {
        scrollView.contentOffset = CGPointMake([cell rightUtilityButtonsWidth], 0);
    }
}
#pragma mark - 处理置顶按钮
- (void)handleStickedButtonPressedWithCell:(JGJWorkCircleProGroupCell *)cell ButtonType:(ProGroupCellButtonType)buttonType {
    cell.proListModel.is_sticked = !cell.proListModel.is_sticked;
    NSString *action = cell.proListModel.is_sticked ? @"stickChat" : @"disStickChat";
    NSDictionary *parameters = @{@"ctrl" : @"Chat",
                                 @"action" : action,
                                 @"class_type" : cell.proListModel.class_type?: @"",
                                 @"group_id" : cell.proListModel.group_id?:@""};
    __weak typeof(self) weakSelf = self;
    [TYLoadingHub showLoadingWithMessage:nil];
    [JGJSocketRequest WebSocketWithParameters:parameters success:^(id responseObject) {
        [TYLoadingHub hideLoadingView];
        if ([weakSelf.delegate respondsToSelector:@selector(handleJGJWorkCircleBottomCell:didSelectedWorlCircleModel:)]) {
            [weakSelf.delegate handleJGJWorkCircleBottomCell:self didSelectedWorlCircleModel:cell.proListModel];
        }
    } failure:^(NSError *error,id values) {
        [TYLoadingHub hideLoadingView];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(handleJGJJGJWorkCircleBottomCellDidSelected:) ] && !self.proListModel.isUnProInfo) {
        [self.delegate handleJGJJGJWorkCircleBottomCellDidSelected:self.proListModel.group_info];
    }
}

#pragma mark - buttonAction
#pragma mark - 头部按钮按下
- (void)tableViewHeaderButtonPressed:(WorkCircleHeaderFooterViewButtonType) buttonType {
    if (self.workCircleHeaderFooterViewBlock) {
        self.workCircleHeaderFooterViewBlock(buttonType);
    }
}

#pragma mark - tap关闭班组
- (void)handleShutGroupLable:(id)sender {
    if (self.workCircleHeaderFooterViewBlock) {
        self.workCircleHeaderFooterViewBlock(WorkCircleFooterViewShutGroupType);
    }
}

#pragma mark - 点击扫码和创建班组
- (void)defaultGroupBtnClick:(JGJWorkCircleDefaultProGroupCell *)jgjWorkCircleDefaultProGroupCell clickType:(WorkCircleHeaderFooterViewButtonType )clickType {
    [self tableViewHeaderButtonPressed:clickType];
}

- (void)dealloc
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
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

@end

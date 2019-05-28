//
//  JGJSurePoorBillShowView.m
//  mix
//
//  Created by Tony on 2017/10/11.
//  Copyright © 2017年 JiZhi. All rights reserved.
//

#import "JGJSurePoorBillShowView.h"
#import "JGJPoorBillWorkTimeTableViewCell.h"
#import "JGJRecordBillDetailViewController.h"
#import "YZGGetBillModel.h"
#import "UILabel+JGJCopyLable.h"
#import "UILabel+GNUtil.h"
@interface JGJSurePoorBillShowView ()


@end
@implementation JGJSurePoorBillShowView

+ (void)showPoorBillAndModel:(JGJPoorBillListDetailModel *)model AndDelegate:(id)delegate andindexPath:(NSIndexPath *)indextpath andHidenismine:(BOOL)ismine
{
    CGFloat PoorHeight;
    
    
    if (![NSString isEmpty: model.accounts_type]) {
        if ([model.accounts_type intValue] == 3) {
            
            PoorHeight = 220;
            
        }else{
            
            if ([model.accounts_type intValue] == 4) {
           
                PoorHeight = 360;

            }else if ([model.accounts_type intValue] == 2) {
                
                PoorHeight = 270;
            }
            else{
           
                PoorHeight = 300;
            }
        }
        
    }else{
        
          PoorHeight = 370;
    }
    
    JGJSurePoorBillShowView *SurePoorBillShowView = [[[NSBundle mainBundle]loadNibNamed:@"JGJSurePoorBillShowView" owner:nil options:nil]firstObject];
    SurePoorBillShowView.delegate = delegate;
    [SurePoorBillShowView setFrame:CGRectMake(0, TYGetUIScreenHeight, TYGetUIScreenWidth, PoorHeight)];

    SurePoorBillShowView.modifyButton.layer.masksToBounds = YES;
    SurePoorBillShowView.modifyButton.layer.cornerRadius = 2.5;
    SurePoorBillShowView.modifyButton.layer.borderColor = AppFontd7252cColor.CGColor;
    SurePoorBillShowView.modifyButton.layer.borderWidth = .5;
    SurePoorBillShowView.agreeButton.backgroundColor = AppFontd7252cColor;
    SurePoorBillShowView.agreeButton.layer.cornerRadius = 2.5;
    SurePoorBillShowView.agreeButton.layer.masksToBounds = YES;
    SurePoorBillShowView.mateWorkitemsItems = model;
    if (indextpath) {
        
        SurePoorBillShowView.indexpath = indextpath;

    }
    SurePoorBillShowView.ismine = ismine;
    
    SurePoorBillShowView.placeView = [[UIButton alloc]initWithFrame:[UIScreen mainScreen].bounds];
    SurePoorBillShowView.placeView.tag = 222;
    SurePoorBillShowView.placeView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.4];
    SurePoorBillShowView.placeView.userInteractionEnabled = YES;
    
    [SurePoorBillShowView initTableView];

    [SurePoorBillShowView.placeView addSubview:SurePoorBillShowView];
    
}


- (void)animationShow
{
    CGFloat PoorHeight;

    if (![NSString isEmpty: self.mateWorkitemsItems.accounts_type ]) {
        if ([self.mateWorkitemsItems.accounts_type intValue] == 3) {
            PoorHeight = 220;
        }else{
            if ([self.mateWorkitemsItems.accounts_type intValue] == 4) {
               
                PoorHeight = 360;
            }else if ([self.mateWorkitemsItems.accounts_type intValue] == 2) {
                
                PoorHeight = 270;
            }
            else{
                PoorHeight = 300;
            }
        }
    }else{
        PoorHeight = 370;
    }
    PoorHeight = PoorHeight + JGJ_IphoneX_BarHeight;
    [UIView animateWithDuration:.3 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -PoorHeight);
    }];
    [[[UIApplication sharedApplication]keyWindow] addSubview:self.placeView];

}
-(void)removeSurePoorBillview
{
    [self removeSlefView];


}
-(void)setIndexpath:(NSIndexPath *)indexpath
{
    _indexpath = indexpath;
}
- (void)clickTaget
{

    [self removeSlefView];

}
-(void)initTableView
{
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.mateWorkitemsItems.accounts_type intValue] == 1 || [self.mateWorkitemsItems.accounts_type intValue] == 5) {
        
        if ([self.mateWorkitemsItems.accounts_type intValue] == 1) {
            
            self.accountTypeLable.text = @"点工";
            self.titleArr = @[@"上班",@"加班",@"上班标准",@"加班标准"];
            
        }else {
            
            self.accountTypeLable.text = @"包工记工天";
            self.titleArr = @[@"上班",@"加班",@"上班标准",@"加班标准"];
        }
        
    }else if ([self.mateWorkitemsItems.accounts_type intValue] == 2){
        
        self.titleArr = @[@"工钱",@"单价",@"数量"];
        self.accountTypeLable.text = @"包工";
        
    }else if([self.mateWorkitemsItems.accounts_type intValue] == 3){
        
        self.titleArr = @[@"金额"];
        self.accountTypeLable.text = @"借支";
    }else if ([self.mateWorkitemsItems.accounts_type intValue] == 4){
        
        self.titleArr = @[@"本次结算金额",JLGisLeaderBool?@"本次实付金额":@"本次实收金额",@"补贴金额",@"奖励金额",@"罚款金额",@"抹零金额",];
        self.accountTypeLable.text = @"结算";
    }
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, TYGetUIScreenWidth, TYGetUIScreenHeight - CGRectGetHeight(self.frame))];
    [button addTarget:self action:@selector(clickTaget) forControlEvents:UIControlEventTouchUpInside];
    [self.placeView addSubview:button];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView) name:JGJRemovePoorView object:nil];

    [self getNeteData];

}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(NSArray *)titleArr
{
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}
- (UIColor *)UIClolorFromMineStr:(NSString *)mine FromOtherStr:(NSString *)other
{
    if ([NSString isEmpty: mine ]) {
        mine = @"0";
    }
    if ([NSString isEmpty: other ]) {
        other = @"0";
    }
    if ([mine floatValue] == [other floatValue]) {
        return AppFont333333Color;
    }else{
        return AppFontEB4E4EColor;
    }
    
}
- (JGJPoorBillWorkTimeTableViewCell *)loadTinyMarkBillTableViewFromIndexpath:(NSIndexPath *)indexPath{
    
    JGJPoorBillWorkTimeTableViewCell *cell = [JGJPoorBillWorkTimeTableViewCell cellWithTableView:self.tableview];
    
    cell.subLable.textColor = AppFontEB4E4EColor;
    cell.titleLable.text = _titleArr[indexPath.row];
    cell.titleLable.font = [UIFont systemFontOfSize:13];
    cell.titleLable.textColor = AppFont333333Color;
    
    if (indexPath.row == 0) {
        
        cell.centerTitleComstance.constant = 3;
        
    }else if (indexPath.row == 1) {
        
        cell.centerTitleComstance.constant = -3;
        
    }else if (indexPath.row == 2) {
        
        cell.centerTitleComstance.constant = 3;
    }else {
        
        cell.centerTitleComstance.constant = -3;
    }
    
    if (indexPath.row >= 2) {
        
        cell.lineLable.hidden = YES;
        
    }

    if (indexPath.row == 0) {
        
        cell.lineLable.hidden = YES;
        if (!self.yzgMateShowpoorModel) {
                
            cell.centerLable.text = @"";
            cell.subLable.text = @"";
                
        }else{
                
            if ([self.yzgMateShowpoorModel.main_manhour?:@"" floatValue] <= 0) {
                    
                cell.centerLable.text = @"休息";
               
            }else{
                    
                cell.centerLable.text = [NSString stringWithFormat:@"%@小时",self.yzgMateShowpoorModel.main_manhour];
                        
            }
            if ([self.yzgMateShowpoorModel.second_manhour?:@"0" floatValue] <= 0) {
                    
                cell.subLable.text = @"休息";
                    
            }else{
                    
                cell.subLable.text = [NSString stringWithFormat:@"%@小时",self.yzgMateShowpoorModel.second_manhour];
                
            }
            
        }
        
    }else if (indexPath.row == 1){
            
        if (!self.yzgMateShowpoorModel) {
            
            cell.centerLable.text = @"";
            cell.subLable.text = @"";
           
        }else{
            
            //左边
            if ([self.yzgMateShowpoorModel.main_overtime?:@"0" floatValue] <= 0) {
                
                cell.centerLable.text  = @"无加班";
            }else{
                    
                cell.centerLable.text = [NSString stringWithFormat:@"%@小时",self.yzgMateShowpoorModel.main_overtime];
    
            }
            
            //右边
            if ([self.yzgMateShowpoorModel.second_overtime?:@"0" floatValue] <= 0) {
                
                cell.subLable.text = @"无加班";
               
            }else{
                    
                cell.subLable.text = [NSString stringWithFormat:@"%@小时",self.yzgMateShowpoorModel.second_overtime];
 
            }
        }

        
    }else if (indexPath.row == 2){
        
        cell.lineLable.hidden = YES;
        if (!self.yzgMateShowpoorModel) {
            
            cell.centerLable.text = @"";
            cell.subLable.text = @"";
        }else{
            
            cell.centerLable.text = [NSString stringWithFormat:@"%@小时算1个工",self.yzgMateShowpoorModel.main_w_h_tpl];
            cell.subLable.text = [NSString stringWithFormat:@"%@小时算1个工",self.yzgMateShowpoorModel.second_w_h_tpl];
        }

        
    }else if(indexPath.row == 3){
        
        if (!self.yzgMateShowpoorModel) {
            
            cell.centerLable.text = @"";
            cell.subLable.text = @"";
            
        }else{
      
            if (self.yzgMateShowpoorModel.main_hour_type == 0) {
                
                cell.centerLable.text = [NSString stringWithFormat:@"%@小时算1个工",self.yzgMateShowpoorModel.main_o_h_tpl];
                
            }else {
                
                cell.centerLable.text = [NSString stringWithFormat:@"%.2f元/小时",self.yzgMateShowpoorModel.main_o_s_tpl];
                
            }
            
            if (self.yzgMateShowpoorModel.second_hour_type == 0) {
                
                cell.subLable.text = [NSString stringWithFormat:@"%@小时算1个工",self.yzgMateShowpoorModel.second_o_h_tpl];
            }else {
                
                cell.subLable.text = [NSString stringWithFormat:@"%.2f元/小时",self.yzgMateShowpoorModel.second_o_s_tpl];
            }
            
        }

    }
        
    return cell;
    
}
- (JGJPoorBillWorkTimeTableViewCell *)loadContractMarkBillTableViewFromIndexpath:(NSIndexPath *)indexPath{
    
    JGJPoorBillWorkTimeTableViewCell *cell = [JGJPoorBillWorkTimeTableViewCell cellWithTableView:self.tableview];
    
    cell.subLable.textColor = AppFontEB4E4EColor;
    cell.titleLable.text = _titleArr[indexPath.row];
    cell.titleLable.font = [UIFont systemFontOfSize:13];
    cell.titleLable.textColor = AppFont333333Color;


     if (indexPath.row == 1) {
        
        cell.centerTitleComstance.constant = 3;
        
    }else if (indexPath.row == 2) {
        
        cell.centerTitleComstance.constant = -3;
    }
    
    if (indexPath.row == 0) {
        
        
        if (!self.yzgMateShowpoorModel) {
            cell.centerLable.text = @"";
            cell.subLable.text = @"";
        }else{
            
            cell.centerLable.text = self.yzgMateShowpoorModel.main_set_amount;
            
            cell.subLable.text = self.yzgMateShowpoorModel.second_set_amount;
        }
    }else if (indexPath.row == 1){
        
        cell.lineLable.hidden = YES;
        if (!self.yzgMateShowpoorModel) {
            cell.centerLable.text = @"";
            cell.subLable.text = @"";
        }else{
            cell.centerLable.text = self.yzgMateShowpoorModel.main_set_unitprice;
            
            cell.subLable.text = self.yzgMateShowpoorModel.second_set_unitprice;
        }

    }else{
        
        cell.lineLable.hidden = YES;
        if (!self.yzgMateShowpoorModel) {
            cell.centerLable.text = @"";
            cell.subLable.text = @"";
        }else{
            cell.centerLable.text = self.yzgMateShowpoorModel.main_set_quantities;
            
            cell.subLable.text = self.yzgMateShowpoorModel.second_set_quantities;

        }
        
    }


    return cell;
}
- (JGJPoorBillWorkTimeTableViewCell *)loadBrrowMarkBillTableViewFromIndexpath:(NSIndexPath *)indexPath{
    JGJPoorBillWorkTimeTableViewCell *cell = [JGJPoorBillWorkTimeTableViewCell cellWithTableView:self.tableview];
    if (indexPath.row>=3) {
        cell.titleLable.font = [UIFont systemFontOfSize:13];
        cell.titleLable.textColor = AppFont333333Color;
        cell.lineLable.hidden = YES;
    }else if (indexPath.row == 2){
        cell.lineLable.hidden = YES;
    }
    cell.subLable.textColor = AppFontEB4E4EColor;
    
    cell.titleLable.text = _titleArr[indexPath.row];
    

    if (!self.yzgMateShowpoorModel) {
        cell.centerLable.text = @"";
        cell.subLable.text = @"";
    }else{
        cell.centerLable.text =self.yzgMateShowpoorModel.main_set_amount;
        cell.subLable.text =  self.yzgMateShowpoorModel.second_set_amount;

    }
    return cell;
    
}
- (JGJPoorBillWorkTimeTableViewCell *)loadCloseAccountMarkBillTableViewFromIndexpath:(NSIndexPath *)indexPath{
    JGJPoorBillWorkTimeTableViewCell *cell = [JGJPoorBillWorkTimeTableViewCell cellWithTableView:self.tableview];
    if (indexPath.row>=1) {
        cell.titleLable.font = [UIFont systemFontOfSize:13];
        cell.titleLable.textColor = AppFont333333Color;
        cell.lineLable.hidden = YES;
    }else if (indexPath.row == 2){
        cell.titleLable.font = [UIFont boldSystemFontOfSize:13];
        cell.lineLable.hidden = YES;
    }
    cell.subLable.textColor = AppFontEB4E4EColor;
    
    cell.titleLable.text = _titleArr[indexPath.row];

   
#pragma mark - 调整一下布局  显示不下
    if (indexPath.row == 0) {//本次结算金额
        cell.centerLable.text = self.yzgMateShowpoorModel.main_set_amount?:@"";
        cell.subLable.text = self.yzgMateShowpoorModel.second_set_amount?:@"";

    }else if (indexPath.row == 1){//本次实收金额
        cell.centerLable.text = self.yzgMateShowpoorModel.main_pay_amount?:@"";
        cell.subLable.text = self.yzgMateShowpoorModel.second_pay_amount?:@"";

    }else if (indexPath.row == 2){//补贴金额
        cell.centerLable.text = self.yzgMateShowpoorModel.main_subsidy_amount?:@"";
        cell.subLable.text = self.yzgMateShowpoorModel.second_subsidy_amount?:@"";

    }else if (indexPath.row == 3){//奖励金额
        cell.centerLable.text = self.yzgMateShowpoorModel.main_reward_amount?:@"";
        cell.subLable.text = self.yzgMateShowpoorModel.second_reward_amount?:@"";

    }else if (indexPath.row == 4){//罚款金额
        cell.centerLable.text = self.yzgMateShowpoorModel.main_penalty_amount?:@"";
        cell.subLable.text = self.yzgMateShowpoorModel.second_penalty_amount?:@"";

    }else if (indexPath.row == 5){//抹零金额
      
        cell.centerLable.text = self.yzgMateShowpoorModel.main_deduct_amount?:@"";
        cell.subLable.text = self.yzgMateShowpoorModel.second_deduct_amount?:@"";   

    }
    return cell;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JGJPoorBillWorkTimeTableViewCell *cell;
    if ([self.mateWorkitemsItems.accounts_type intValue] == 1 || [self.mateWorkitemsItems.accounts_type intValue] == 5) {
        
        cell = [self loadTinyMarkBillTableViewFromIndexpath:indexPath];
        
    }else if ([self.mateWorkitemsItems.accounts_type intValue] == 2){
        
        cell = [self loadContractMarkBillTableViewFromIndexpath: indexPath];
        
    }else if ([self.mateWorkitemsItems.accounts_type intValue] == 3){
        
        cell = [self loadBrrowMarkBillTableViewFromIndexpath:indexPath];
        
    }else if ([self.mateWorkitemsItems.accounts_type intValue] == 4){
        
        cell = [self loadCloseAccountMarkBillTableViewFromIndexpath:indexPath];

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
#pragma mark - 设置--显示
    if ([self.yzgMateShowpoorModel.main_line?:@"0" intValue] == 1) {
        cell.centerLable.text = @"-";
        
    }
    if ([self.yzgMateShowpoorModel.second_line?:@"0" intValue] == 1) {
        
        cell.subLable.text = @"-";
        
    }
    return cell;
}
-(void)setMateWorkitemsItems:(JGJPoorBillListDetailModel *)mateWorkitemsItems
{
    if (!_mateWorkitemsItems) {
        _mateWorkitemsItems = [JGJPoorBillListDetailModel new];
    }
    _mateWorkitemsItems = mateWorkitemsItems;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 30;
}
- (void)removeSlefView
{
    [self removeFromSuperview];
    [self.placeView removeFromSuperview];

}

- (void)removePoorView
{
    
    for (UIView *view in [[[UIApplication sharedApplication]keyWindow] subviews]) {
        
        if ([view isKindOfClass:[UIView class]] && view.tag == 222) {
            
            [view removeFromSuperview];
            
        }
    }

}

+ (void)removeView
{

    for (UIView *view in [[[UIApplication sharedApplication]keyWindow] subviews]) {

        if ([view isKindOfClass:[UIView class]] && view.tag == 222) {
            
            [view removeFromSuperview];
            
        }
    }
}
- (IBAction)deleteThePoorBill:(id)sender {
    [self removeFromSuperview];
    [self.placeView removeFromSuperview];

}
#pragma mark - 修改差账
- (IBAction)clickModifyBtn:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJSurePoorBillShowClickLookDetailBtnAndIndexpath: andTPLmodel:)]) {
        [self.delegate JGJSurePoorBillShowClickLookDetailBtnAndIndexpath:_indexpath andTPLmodel:self.yzgGetBillModel];
    }


}
//同意他人的修改
- (IBAction)clickAgreeButton:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(JGJSurePoorBillShowClickAgreePoorBillBtnAndIndexpath: andTPLmodel:)]) {
        [self.delegate JGJSurePoorBillShowClickAgreePoorBillBtnAndIndexpath:_indexpath andTPLmodel:self.yzgGetBillModel];
    }
    
}
- (void)getNeteData{
    
    __weak typeof(self) weakSelf = self;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:self.mateWorkitemsItems.id forKey:@"id"];
    if (![NSString isEmpty:self.mateWorkitemsItems.agency_uid]) {
        
        [dic setObject:self.mateWorkitemsItems.group_id ? : @"" forKey:@"group_id"];
    }
    
    [TYLoadingHub showLoadingNoDataDefultWithMessage:nil];
    
    [JLGHttpRequest_AFN PostWithApi:@"v2/workday/showpoorTip" parameters:dic success:^(id responseObject) {
        
        YZGMateShowpoorModel *yzgMateShowpoorModel = [YZGMateShowpoorModel new];
        [yzgMateShowpoorModel mj_setKeyValues:responseObject];
        weakSelf.yzgMateShowpoorModel = yzgMateShowpoorModel;
        weakSelf.yzgMateShowpoorModel.accounts_type.code = [weakSelf.mateWorkitemsItems.accounts_type intValue];
        
        // 右边
        weakSelf.recordedLable.text =  weakSelf.yzgMateShowpoorModel.main_name?:@"";
        
        
        weakSelf.contentLable.text = weakSelf.yzgMateShowpoorModel.describe;
        [weakSelf.contentLable markText:weakSelf.yzgMateShowpoorModel.second_name_mark?:@"" withColor:AppFontEB4E4EColor];
        // 左边
        weakSelf.recorderLable.text = weakSelf.yzgMateShowpoorModel.second_name;
        weakSelf.recorderLable.textColor = AppFontEB4E4EColor;
        
        weakSelf.dateLable.text = weakSelf.yzgMateShowpoorModel.date;
        weakSelf.yzgGetBillModel.id = [NSString stringWithFormat:@"%ld", (long)weakSelf.yzgMateShowpoorModel.id];
        
        //3.0.0 self.yzgGetBillModel 他在这个页面用这个模型调了两个接口，一个有id一个没有id导致有时参数错误。
        if ([NSString isEmpty:weakSelf.yzgGetBillModel.id]) {
            
            self.yzgGetBillModel.id = self.mateWorkitemsItems.id;
        }
        
        if ([weakSelf.mateWorkitemsItems.accounts_type intValue] == 4) {
            
            [weakSelf.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
        }
        [weakSelf.tableview reloadData];
        [TYLoadingHub hideLoadingView];
        [self animationShow];
        
    }failure:^(NSError *error) {
        
        [TYLoadingHub hideLoadingView];
    }];
}


-(float)RowDrewHeight:(NSString *)Str
{
    UILabel *lable = [[UILabel alloc]init];
    lable = [[UILabel alloc] init];
    lable.font = [UIFont boldSystemFontOfSize:15];
    lable.text = Str;
    lable.backgroundColor = [UIColor clearColor];
    lable.numberOfLines = 0;
    lable.textColor = [UIColor darkTextColor];
    lable.lineBreakMode = NSLineBreakByTruncatingTail;
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 1000);
    CGSize expectSize = [lable sizeThatFits:maximumLabelSize];
    
    return expectSize.width + 1;
    
}

@end

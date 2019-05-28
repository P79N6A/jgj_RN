//
//  YZGMateShowpoor.m
//  mix
//
//  Created by Tony on 16/2/26.
//  Copyright © 2016年 JiZhi. All rights reserved.
//

#import "YZGMateShowpoor.h"
#import "TYAnimate.h"
#import "TYBaseTool.h"
#import "NSString+Extend.h"
#import "YZGMateShowpoorModel.h"
#import "YZGMateWorkitemsModel.h"
#import "UITableView+TYSeparatorLine.h"
#import "YZGMateShowpoorTableViewCell.h"

static const CGFloat dayWorkViewRation = 720.f/750.f;//点工
static const CGFloat contractWorkViewRation = 590.f/750.f;//包工
static const CGFloat borrowingWorkViewRation = 460.f/750.f;//借支

@interface YZGMateShowpoor ()
<
    UITableViewDelegate,
    UITableViewDataSource
>
{
    NSInteger _tableViewRowsNum;
    NSArray *_titleLabelArray;
    NSMutableArray *_firstTitleArray;
    NSMutableArray *_secondTitleArray;
    NSMutableArray *_thirdTitleArray;
    CGFloat _tableViewRation;
    CGFloat _viewRation;
    NSArray *_tableViewRowsNumArray;
    NSArray *_viewRationArray;
    NSArray *_firstTitleArrayDatasArray;
}

@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (weak, nonatomic) IBOutlet UIButton *mainTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *secondTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *cloneBillButton;
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *containtColoneBillButtonView;

@property (weak, nonatomic) IBOutlet UILabel *modifyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *modifyImage;

//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutH;

@property (strong, nonatomic) YZGMateShowpoorModel *yzgMateShowpoorModel;
@end

@implementation YZGMateShowpoor

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView{
    self.backgroundColor = [UIColor clearColor];
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];

    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;

    [self initTitleArray];
    
    //添加单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.backGroundView addGestureRecognizer:singleTap];
    
    [UITableView hiddenExtraCellLine:self.tableView];

    _titleLabelArray  = @[@"点工核对账单",@"包工核对账单",@"借支核对账单",@"结算工钱核对账单",@"包工记工天核对账单"];
    
    self.hidden = YES;
    [self.cloneBillButton.layer setLayerBorderWithColor:AppFontd7252cColor width:0.5 radius:5];
    self.containtColoneBillButtonView.backgroundColor = AppFontfafafaColor;
}

- (void)initTitleArray{
    
    _firstTitleArray = [NSMutableArray array];
    _secondTitleArray = [NSMutableArray array];
    _thirdTitleArray = [NSMutableArray array];
    
#pragma mark - 刘远强修改

    _tableViewRowsNumArray = @[@4,@3,@1,@1,@3];
    
    
    
    _viewRationArray = @[@(dayWorkViewRation),@(contractWorkViewRation),@(borrowingWorkViewRation),@(borrowingWorkViewRation),@(dayWorkViewRation)];
    


    
    _firstTitleArrayDatasArray = @[@[@"总价",@"正常上班",@"加班时长",@"工资标准"],
                                   @[@"总价",@"单价",@"数量"],
                                   @[@"总价"],
                                   @[@"总价"],
                                   @[@"总价",@"正常上班",@"加班时长"]
                                   ];
}

#pragma mark - 单击手势
- (void)handleSingleTap:(id)sender
{
    [self removeBtnClick:nil];
}

#pragma mark - tableView
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self titleArrayIsEmpty]) {
        return 0;
    }
    
    return _tableViewRowsNum;
}

- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat cellHeight;
    
    if ([self titleArrayIsEmpty]) {
        return 0;
    }
    
    if (indexPath.row == 0) {
        
        //点工不显示总价
        cellHeight = self.mateWorkitemsItem.accounts_type.code == 1 ? CGFLOAT_MIN : 40;
        
    } else if (_tableViewRowsNum == 4) {
        
        cellHeight = indexPath.row != 3?(90.f/400.f*TYGetViewH(tableView)):(130.f/400.f*TYGetViewH(tableView)) + 5;
        
    }else{
        
        cellHeight = TYGetViewH(tableView)/_tableViewRowsNum + 5;
    }
    
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self titleArrayIsEmpty]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
        return cell;
    }

    YZGMateShowpoorTableViewCell *cell = [YZGMateShowpoorTableViewCell cellWithTableView:tableView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isLastCell = indexPath.row + 1 == _secondTitleArray.count;
    
    NSString *firstString = indexPath.row <= _firstTitleArray.count?_firstTitleArray[indexPath.row]:@"";
    NSString *secondString = indexPath.row <= _secondTitleArray.count?_secondTitleArray[indexPath.row]:@"";
    id thirdString = indexPath.row <= _thirdTitleArray.count?_thirdTitleArray[indexPath.row]:@"";
    
    if ([_yzgMateShowpoorModel.del_diff_left  intValue] == 1) {
        
       secondString = @"--";
        //张程说这个有薪资模板的时候要显示 所以加上了

        if (indexPath.row == 3 && _yzgMateShowpoorModel.main_w_h_tpl) {
            secondString = _secondTitleArray[indexPath.row];
        }
    }

    
    if ([_yzgMateShowpoorModel.del_diff_right intValue] == 1) {
        thirdString = @"--";
        //张程说这个有薪资模板的时候要显示 所以加上了
        if (indexPath.row == 3 && _yzgMateShowpoorModel.main_w_h_tpl) {
            thirdString = _thirdTitleArray[indexPath.row];
        }

    }
    
      
       [cell setFirstTitle:firstString secondTitle:secondString thirdTitle:thirdString];
        
    return cell;
}

#pragma mark - setter
- (void)setMateWorkitemsItem:(MateWorkitemsItems *)mateWorkitemsItem{
    _mateWorkitemsItem = mateWorkitemsItem;
    
    //设置标题
    self.titleLabel.text = _titleLabelArray[mateWorkitemsItem.accounts_type.code - 1];
    
    //通过判断类型转换数据
    NSInteger accountTypeCode = mateWorkitemsItem.accounts_type.code;
    
    _tableViewRowsNum = [_tableViewRowsNumArray[accountTypeCode - 1] integerValue];
    
    _viewRation = [_viewRationArray[accountTypeCode - 1] floatValue];
    
    _firstTitleArray = [NSMutableArray arrayWithArray:_firstTitleArrayDatasArray[accountTypeCode - 1]];
   
    self.viewLayoutH.constant = _viewRation*TYGetUIScreenWidth;
}

- (void)setShowData{
    
    if (!self.mateWorkitemsItem) {
        TYLog(@"没有设置数据model");
        return;
    }
    
    if (!self.yzgMateShowpoorModel) {
        TYLog(@"没有从服务器获取显示的model");
        return;
    }
    if (self.yzgMateShowpoorModel.prompt.modify_marking == 2) {
        //别人
            [self.cloneBillButton setTitle:[NSString stringWithFormat:@"同意%@的记账",self.yzgMateShowpoorModel.second_role == 1?@"工人":@"班组长/工头"] forState:UIControlStateNormal];
    }else{
    //自己
        [self.cloneBillButton setTitle:@"放弃修改" forState:UIControlStateNormal];
    }

    
    [self setTitleButton];
    
    [_secondTitleArray removeAllObjects];
    [_thirdTitleArray removeAllObjects];
    
    NSString *borrowIcon = @"";
    NSString *mainAmount = [NSString stringWithFormat:@"￥%@%@",borrowIcon,self.yzgMateShowpoorModel.main_set_amount];
    
    BOOL isSame = self.yzgMateShowpoorModel.main_set_amount == self.yzgMateShowpoorModel.second_set_amount;
    id secondAmount = [NSString stringWithFormat:@"￥%@%@",borrowIcon, self.yzgMateShowpoorModel.second_set_amount];
    secondAmount = isSame?secondAmount:[self stringToAttributedString:(NSString *)secondAmount];
    [_thirdTitleArray addObject:secondAmount];
    switch (self.mateWorkitemsItem.accounts_type.code) {
        case 1:
            [self setFirstAccountType:mainAmount];
            break;
        case 2:
            [self setSecondAccountType:mainAmount];
            break;
        case 3:
            _secondTitleArray = [NSMutableArray arrayWithObjects:mainAmount, nil];
            break;
            
        case 4:
            _secondTitleArray = [NSMutableArray arrayWithObjects:mainAmount, nil];
            break;
        default:
            break;
    }
    
    self.hidden = NO;
    CGRect startFrame = CGRectMake(0, TYGetViewH(self.contentView) - TYGetViewH(self.view), TYGetViewW(self.contentView), TYGetViewH(self.view));
    
    
    if (self.yzgMateShowpoorModel.prompt.modify_marking == 2) {
        self.modifyImage.image = [UIImage imageNamed:@"RecordWorkpoints_cellOther"];
    }else{
        self.modifyImage.image = [UIImage imageNamed:@"RecordWorkpoints_cellMine"];
    }
    self.modifyLabel.text = self.yzgMateShowpoorModel.prompt.msg;

    
    [TYAnimate showWithView:self.view byStartframe:startFrame endFrame:startFrame];
}

- (void)setTitleButton{
    [self.mainTitleButton setTitleColor:JGJMainColor forState:UIControlStateNormal];
    [self.mainTitleButton.layer setLayerBorderWithColor:JGJMainColor width:0.5 ration:0.08];
    
    self.mainTitleLabel.text = @"我的";
    NSString *second_name = [NSString isEmpty:self.yzgMateShowpoorModel.second_name]?@"用户":self.yzgMateShowpoorModel.second_name;
    NSString *secondString = [NSString stringWithFormat:@"%@(%@)",second_name,self.yzgMateShowpoorModel.second_role == 1?@"工人":@"班组长/工头"];
    [self.secondTitleButton setTitle:secondString forState:UIControlStateNormal];
}

#pragma mark - 设置点工的数据
- (void)setFirstAccountType:(id)mainAmount{
    {
        //main
        //上班时间
        
        NSString *mainManhour = [NSString stringWithFormat:@"%@小时",self.yzgMateShowpoorModel.main_manhour];
        //0表示休息(2.0.3- yj)
        if (![self.yzgMateShowpoorModel.main_manhour floatValue] && [self.yzgMateShowpoorModel.del_diff_left intValue] == 0) {
            mainManhour = @"休息";
        }
        
        if ([self.yzgMateShowpoorModel.del_diff_left intValue] == 1) {
            
            mainManhour = @"--";
        }
        //左边的加班时长
        NSString *mainOvertime = self.yzgMateShowpoorModel.main_overtime != 0?[NSString stringWithFormat:@"%@小时",self.yzgMateShowpoorModel.main_overtime]:@"无加班";
        //工资标准
        NSString *mainWHTpl = [NSString stringWithFormat:@"%@小时(正常)",self.yzgMateShowpoorModel.main_w_h_tpl];
        NSString *mainOHTpl = [NSString stringWithFormat:@"%@小时(加班)",self.yzgMateShowpoorModel.main_o_h_tpl];
        
//总价不需要显示了 2.1.2-yj
        
        NSString *mainTemplateString = [NSString stringWithFormat:@"%@\n%@",mainWHTpl,mainOHTpl];
        
        _secondTitleArray = [NSMutableArray arrayWithObjects:mainAmount,mainManhour,mainOvertime,mainTemplateString, nil];
        
        //second-->这里的second是和服务器传值一致
        BOOL isSame = self.yzgMateShowpoorModel.main_manhour == self.yzgMateShowpoorModel.second_manhour;
        id secondManhour = [NSString stringWithFormat:@"%@小时",self.yzgMateShowpoorModel.second_manhour];
        //0表示休息(2.0.3- yj)
        if (![self.yzgMateShowpoorModel.second_manhour floatValue] && [self.yzgMateShowpoorModel.del_diff_right intValue] == 0) {
            secondManhour = @"休息";
        }
        if ([self.yzgMateShowpoorModel.del_diff_right intValue] == 1) {
            secondManhour = @"--";
        }
        secondManhour = isSame?secondManhour:[self stringToAttributedString:(NSString *)secondManhour];
        [_thirdTitleArray addObject:secondManhour];
        
        isSame = self.yzgMateShowpoorModel.main_overtime == self.yzgMateShowpoorModel.second_overtime;
        id secondOvertime = self.yzgMateShowpoorModel.second_overtime != 0?[NSString stringWithFormat:@"%@小时",self.yzgMateShowpoorModel.second_overtime]:@"无加班";
        secondOvertime = isSame?secondOvertime:[self stringToAttributedString:(NSString *)secondOvertime];
        [_thirdTitleArray addObject:secondOvertime];
        
        isSame = self.yzgMateShowpoorModel.main_s_tpl == self.yzgMateShowpoorModel.second_s_tpl && self.yzgMateShowpoorModel.main_w_h_tpl == self.yzgMateShowpoorModel.main_w_h_tpl&&self.yzgMateShowpoorModel.main_o_h_tpl == self.yzgMateShowpoorModel.main_o_h_tpl;//必须全部相等才是相等
        
//总价不需要显示了 2.1.2-yj
        NSString *secondSTpl = @"";
        NSString *secondWHTpl = [NSString stringWithFormat:@"%@小时(正常)",self.yzgMateShowpoorModel.second_w_h_tpl];
        NSString *secondOHTpl = [NSString stringWithFormat:@"%@小时(加班)",self.yzgMateShowpoorModel.second_o_h_tpl];
        
        
        id secondTemplateString = [NSString stringWithFormat:@"%@\n%@",secondWHTpl,secondOHTpl];
        
        if (!isSame){//转换成富文本
            secondTemplateString = [self stringToAttributedString:(NSString *)secondTemplateString];
            
            isSame = self.yzgMateShowpoorModel.main_s_tpl == self.yzgMateShowpoorModel.second_s_tpl;
            
            
            isSame = self.yzgMateShowpoorModel.main_w_h_tpl == self.yzgMateShowpoorModel.second_w_h_tpl;
            
            isSame = self.yzgMateShowpoorModel.main_o_h_tpl == self.yzgMateShowpoorModel.second_o_h_tpl;
            
        }
        [_thirdTitleArray addObject:secondTemplateString];
    }
}

- (void)setSecondAccountType:(id)mainAmount{
        //main
        //上班时间
        NSString *mainUnitprice = [NSString stringWithFormat:@"￥%@",self.yzgMateShowpoorModel.main_set_unitprice];
    
        NSString *mainQuantities = [NSString stringWithFormat:@"%@",self.yzgMateShowpoorModel.main_set_quantities];
    
        _secondTitleArray = [NSMutableArray arrayWithObjects:mainAmount,mainUnitprice,mainQuantities, nil];
        
        //second-->这里的second是和服务器传值一致
        BOOL isSame = self.yzgMateShowpoorModel.main_set_unitprice == self.yzgMateShowpoorModel.second_set_unitprice;
        id secondUnitprice = [NSString stringWithFormat:@"￥%@",self.yzgMateShowpoorModel.second_set_unitprice];
    
        secondUnitprice = isSame?secondUnitprice:[self stringToAttributedString:(NSString *)secondUnitprice];
        [_thirdTitleArray addObject:secondUnitprice];
        
        isSame = self.yzgMateShowpoorModel.main_set_quantities == self.yzgMateShowpoorModel.second_set_quantities;
        id secondQuantities = [NSString stringWithFormat:@"%@",self.yzgMateShowpoorModel.second_set_quantities];
    
        secondQuantities = isSame?secondQuantities:[self stringToAttributedString:(NSString *)secondQuantities];
        [_thirdTitleArray addObject:secondQuantities];
}

- (void)showpoorView{
    
    if (!self.mateWorkitemsItem) {
        TYLog(@"没有设置数据model");
        return;
    }
    
    if (![[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        [[[UIApplication sharedApplication] delegate].window addSubview:self];
        [self layoutIfNeeded];//改了约束
    }

    
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlworkday/showpoor" parameters:@{@"id":@(self.mateWorkitemsItem.id)} success:^(id responseObject) {
        YZGMateShowpoorModel *yzgMateShowpoorModel = [YZGMateShowpoorModel new];
        [yzgMateShowpoorModel mj_setKeyValues:responseObject];
        weakSelf.yzgMateShowpoorModel = yzgMateShowpoorModel;
        weakSelf.yzgMateShowpoorModel.accounts_type = self.mateWorkitemsItem.accounts_type;
        
        [weakSelf setShowData];
        [weakSelf.tableView reloadData];
    }];
}

- (IBAction)removeBtnClick:(id)sender {
    if ([[[UIApplication sharedApplication] delegate].window.subviews containsObject:self]) {
        self.hidden = YES;
        [self removeFromSuperview];
    }
}

- (IBAction)modifyBtnClick:(id)sender {
    [self removeBtnClick:nil];
    if (self.delegate &&[self.delegate  respondsToSelector:@selector(MateShowpoorModifyBtnClick:)]) {
        [self.delegate MateShowpoorModifyBtnClick:self];
    }
}

- (IBAction)copyBillBtnClick:(id)sender {
    NSMutableDictionary *parametersDic = [NSMutableDictionary dictionary];
    parametersDic[@"id"] = @(self.yzgMateShowpoorModel.id);
    
    NSInteger accountTypeCode = self.mateWorkitemsItem.accounts_type.code;
    
    if (accountTypeCode == 1) {
        parametersDic[@"main_manhour"] = [NSString stringWithFormat:@"%@",self.yzgMateShowpoorModel.second_manhour];
        parametersDic[@"main_overtime"] = [NSString stringWithFormat:@"%@",self.yzgMateShowpoorModel.second_overtime];
    }else if(accountTypeCode == 2){
        parametersDic[@"main_manhour"] = [NSString stringWithFormat:@"%@",self.yzgMateShowpoorModel.second_set_unitprice];
        parametersDic[@"main_overtime"] = [NSString stringWithFormat:@"%@",self.yzgMateShowpoorModel.second_set_quantities];
    }else if(accountTypeCode == 3){
        parametersDic[@"main_manhour"] = @0;
        parametersDic[@"main_overtime"] = @0;
    }else if(accountTypeCode == 4){
        parametersDic[@"main_manhour"] = @0;
        parametersDic[@"main_overtime"] = @0;
    }
    
    
    parametersDic[@"main_set_amount"] = [NSString stringWithFormat:@"@",self.yzgMateShowpoorModel.second_set_amount];
    
    [TYLoadingHub showLoadingWithMessage:@""];
    [JLGHttpRequest_AFN PostWithApi:@"jlworkstream/mpoorinfo" parameters:parametersDic success:^(id responseObject) {

        if (self.delegate &&[self.delegate respondsToSelector:@selector(MateShowpoorCopyBillBtnClick:)]) {
            [self.delegate MateShowpoorCopyBillBtnClick:self];
        }
        [self removeBtnClick:nil];
        [TYLoadingHub hideLoadingView];
        [TYShowMessage showSuccess:@"修改账单成功"];
    }failure:^(NSError *error) {
        [TYLoadingHub hideLoadingView];
    }];
}

#pragma mark - 将string 转换成 attributedString
- (NSMutableAttributedString *)stringToAttributedString:(NSString *)string{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:JGJMainColor range:NSMakeRange(0, string.length)];
    return attributedString;
}

#pragma mark - 判断是否有标题
- (BOOL)titleArrayIsEmpty{
    if (_firstTitleArray.count == 0 || _secondTitleArray.count == 0 || _thirdTitleArray.count == 0) {
        return YES;
    }else{
        return NO;
    }
}
@end

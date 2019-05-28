//
//  JLGAuthorizationViewController.m
//  mix
//
//  Created by jizhi on 15/11/17.
//  Copyright © 2015年 JiZhi. All rights reserved.
//

#import "JLGAuthorizationViewController.h"

@interface JLGAuthorizationViewController()

@property (strong,nonatomic) JLGDatePickerView *jlgDatePickerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet JLGPickerView *dataPicker;
@property (strong, nonatomic) IBOutlet JLGCityPickerView *cityPickerView;

//Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomH;
@end

@implementation JLGAuthorizationViewController

- (void)viewDidLoad{
    [super viewDidLoad];

    //数据初始化
    [self initData];
#if TYKeyboardObserver
    // 键盘通知
    // 键盘的frame发生改变时发出的通知（位置和尺寸）
    [TYNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
#endif
}

#if TYKeyboardObserver
- (void)dealloc{
    [TYNotificationCenter removeObserver:self];
}

#pragma mark - 监控键盘
/**
 * 键盘的frame发生改变时调用（显示、隐藏等）
 */
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    // 动画的持续时间
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect beginKeyboardRect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = beginKeyboardRect.origin.y - endKeyboardRect.origin.y;
    
    __weak typeof(self) weakSelf = self;
    // 执行动画
    [UIView animateWithDuration:duration animations:^{
        //显示
        weakSelf.tableViewBottomH.constant += yOffset;
        [weakSelf.tableView layoutIfNeeded];
    }];
}
#endif

#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if(section == 1){
        return 4;
    }else {
        return 3;
    }
}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ((indexPath.section == 2) && indexPath.row != 0) {
        return tableViewCellHeight;
    }
    
    return 43;
}

//头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section != 2) {
        return tableViewHeadHeight;
    }else{
        return 4;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"个人信息";
    }else if (section == 1){
        return @"工作相关";
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return  nil;
    }
    
    //添加header的Label
    UILabel * label = [[UILabel alloc] init];
    label.text = sectionTitle;
    label.textColor = TYColorHex(0xadadad);
    label.font = [UIFont systemFontOfSize:13.0];
    label.frame = CGRectMake(0, 0, TYGetUIScreenWidth, tableViewHeadHeight);
    [self setHeaderViewLabelAlignment:label];
    
    //自定义header
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, tableViewHeadHeight)];
    [headerView setBackgroundColor:JGJMainBackColor];
    [headerView addSubview:label];
    return headerView;
}

- (void)setHeaderViewLabelAlignment:(UILabel *)label{
    label.textAlignment = NSTextAlignmentLeft;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSUInteger section = indexPath.section;
    
    switch (section) {
        case 0:
        {
            if (indexPath.row != 3) {
                cell = [JLGRegisterInfoTableViewCell cellWithTableView:tableView];

                JLGRegisterInfoTableViewCell *returnCell = (JLGRegisterInfoTableViewCell *)cell;
                returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
                
                [self setRegisterInfoCellDetailTF:returnCell indexPath:indexPath];
                returnCell.indexPath = indexPath;
                [self blockWithCell:returnCell];

                returnCell.detailTF.userInteractionEnabled = indexPath.row!=4;
                returnCell.onlyNum = NO;
                return returnCell;
            }else{
                JLGRegisterSexTableViewCell *returnCell = [JLGRegisterSexTableViewCell cellWithTableView:tableView];
                [returnCell setSexNum:[self.mateRegisterInfo[@"gender"] integerValue]];
                return returnCell;
            }
        }
            break;
        case 1:
        {
            if (indexPath.row < 3) {
                cell = [JLGRegisterClickTableViewCell cellWithTableView:tableView];
                
                JLGRegisterClickTableViewCell *returnCell = (JLGRegisterClickTableViewCell *)cell;
                returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
                
                [self setRegisterClickCellDetailTF:returnCell indexPath:indexPath];
                
                returnCell.indexPath = indexPath;
                return returnCell;
            }else{
                cell = [JLGRegisterInfoTableViewCell cellWithTableView:tableView];
                
                JLGRegisterInfoTableViewCell *returnCell = (JLGRegisterInfoTableViewCell *)cell;
                returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
                
                [self setRegisterInfoCellDetailTF:returnCell indexPath:indexPath];
                returnCell.indexPath = indexPath;
                [self blockWithCell:returnCell];
                returnCell.onlyNum = YES;
                
                return returnCell;
            }
        }
            break;
        case 2:
        {
            if (indexPath.row == 0)
            {
                cell = [JLGRegisterClickTableViewCell cellWithTableView:tableView];
   
                JLGRegisterClickTableViewCell *returnCell = (JLGRegisterClickTableViewCell *)cell;
                returnCell.indexPath = indexPath;
                returnCell.redStarImage.hidden = YES;
                returnCell.titleLabel.text = self.authoInfosArray[indexPath.section][indexPath.row][0];
                
                [self setRegisterClickCellDetailTF:returnCell indexPath:indexPath];
                return returnCell;
            }
            
            //cell增加子控件
            cell = [[UITableViewCell alloc] init];
            cell.frame = CGRectMake(0, 0,TYGetUIScreenWidth, tableViewCellHeight);
            cell = [self cellAddSubView:cell WithRow:indexPath.row];
        }
            break;
        default:
            break;
    }

    return cell;
}

- (void)setRegisterInfoCellDetailTF:(JLGRegisterInfoTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath{
    NSString *keyString = self.mateRegisterInfo[[self getKeyByIndexPath:indexPath]];
    //设置显示的内容
    if (keyString) {
        returnCell.detailTF.text = keyString;
    }else{
        returnCell.detailTF.placeholder = self.authoInfosArray[indexPath.section][indexPath.row][1];
    }
    returnCell.detailTF.secureTextEntry = indexPath.row == 0;
}

- (void )setRegisterClickCellDetailTF:(JLGRegisterClickTableViewCell *)returnCell indexPath:(NSIndexPath *)indexPath{
    NSString *keyString = self.mateRegisterInfo[[self getKeyByIndexPath:indexPath]];
    //设置显示的内容
    if (keyString) {
        returnCell.detailTF.text = keyString;
        returnCell.detailTF.textColor = [UIColor blackColor];
    }else{
        returnCell.detailTF.text = self.authoInfosArray[indexPath.section][indexPath.row][1];
        returnCell.detailTF.textColor = TYColorHex(0xb9b9b9);
    }
}

//cell增加子控件
- (UITableViewCell *)cellAddSubView:(UITableViewCell *)cell WithRow:(NSInteger )row{

    if (row == 1) {
        [self addLabel:cell];
    }else if(row == 2){
        [self addButton:cell];
    }
    
    return cell;
}

- (void)addLabel:(UITableViewCell *)cell{
    //添加labelk
    UILabel *confirmLabel = [[UILabel alloc] init];
    confirmLabel.enabled = NO;
    confirmLabel.frame = CGRectMake(0, 0, 160, cell.frame.size.height);
    confirmLabel.center = cell.center;
    confirmLabel.text = @"请确认以上信息准确无误";
    confirmLabel.textColor = TYColorHex(0xadadad);
    confirmLabel.backgroundColor = [UIColor whiteColor];
    confirmLabel.textAlignment = NSTextAlignmentCenter;
    confirmLabel.font = [UIFont systemFontOfSize:12.0];
    
    UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(10,cell.frame.size.height/2, TYGetUIScreenWidth - 20, 0.5)];
    lable.backgroundColor = AppFontdbdbdbColor;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell addSubview:lable];
    [cell addSubview:confirmLabel];
}

- (void)addButton:(UITableViewCell *)cell{
    //添加button
    UIButton *finishButton = [[UIButton alloc] init];
    CGFloat width = cell.frame.size.width*0.9;
    finishButton.frame = TYSetRectWidth(cell.bounds, width);
    
    finishButton.center = cell.center;
    finishButton.backgroundColor = JGJMainColor;
    [finishButton.layer setLayerCornerRadius:4.0];
    [finishButton setTitle:@"保存" forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(finishBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.backgroundColor = [UIColor clearColor];
    [cell addSubview:finishButton];
}

//cell的选择操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //第0组不用弹出
    if (indexPath.section == 0 && indexPath.row != 4) {
        return;
    }
    
    //第1组最后一个不用弹出
    if (indexPath.section == 1 && indexPath.row == 3) {
        return;
    }
    
    //第2组的第1，2个不弹出
    if (indexPath.section == 2 && (indexPath.row == 1 || indexPath.row == 2)) {
        return ;
    }
    
    if (indexPath.section == 0) {
        [self.view addSubview:self.jlgDatePickerView];
//        [[[UIApplication sharedApplication] delegate].window addSubview:self.jlgDatePickerView];
        [self.jlgDatePickerView showDatePickerByIndexPath:indexPath];
    }
    
    if (indexPath.section == 1) {
        if(indexPath.row == 0){
            self.cityPickerView.onlyShowCitys = NO;
            [self.cityPickerView showCityPickerByIndexPath:indexPath];
        }else if(indexPath.row == 1){
//            [self.dataPicker showPickerByIndexPath:indexPath dataArray:self.projectTypesArray title:@"请选择项目类型" isMulti:NO];
            
            JLGProjectTypeViewController *projectTypeVc = [[UIStoryboard storyboardWithName:@"ManageProject" bundle:nil] instantiateViewControllerWithIdentifier:@"projectType"];
            projectTypeVc.delegate = self;
            projectTypeVc.selectedSingle = NO;
            projectTypeVc.projectTypesArray = self.projectTypesArray;
            projectTypeVc.selectedArray = self.projectTypesSelectArray;
            
            [self.navigationController pushViewController:projectTypeVc animated:YES];
        }else if(indexPath.row == 2){
            [self.dataPicker showPickerByIndexPath:indexPath dataArray:self.workTypesArray title:@"请选择工种" isMulti:NO];
        }
//        else if(indexPath.row == 3){
//            [self.dataPicker showPickerByIndexPath:indexPath dataArray:self.skillTypesArray title:@"请选择熟练度" isMulti:NO];
//        }
    }else if(indexPath.section == 2){//剩下的情况都是跳出城市选择
        self.cityPickerView.onlyShowCitys = YES;
        [self.cityPickerView showCityPickerByIndexPath:indexPath];
    }
    
    [self.view endEditing:YES];
}

#pragma mark - 完成的按钮
- (void)finishBtnClick:(UIButton *)sender{
    if (![self checkBaseData]) {
        return;
    }
    
    if(!self.parametersDic[@"age"]){
        [TYShowMessage showPlaint:@"请输入年龄"];
        return;
    }
    
    if(!self.parametersDic[@"homearea"]){
        [TYShowMessage showPlaint:@"请选择家乡"];
        return;
    }
    
    if(!self.parametersDic[@"protype"]){
        [TYShowMessage showPlaint:@"请选择项目类型"];
        return;
    }
    

    if(!self.parametersDic[@"worktype"]){
        [TYShowMessage showPlaint:@"请选择工种"];
        return;
    }
    
    if(![self.parametersDic[@"workyear"] integerValue]){
        [TYShowMessage showPlaint:@"请输入工龄"];
        return;
    }
    
    [TYShowMessage showHUDWithMessage:@"注册中，请稍候..."];
    __weak typeof(self) weakSelf = self;
    [JLGHttpRequest_AFN PostWithApi:@"jlsignup/register" parameters:self.parametersDic success:^(id responseObject) {
        [TYUserDefaults setBool:YES forKey:JLGLogin];
        [TYUserDefaults setBool:YES forKey:JLGMateIsInfo];
        [TYUserDefaults setObject:responseObject[JLGToken] forKey:JLGToken];
        
        [TYUserDefaults synchronize];
        [TYShowMessage showSuccess:@"注册成功"];
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

//检查班组长/工头工友都需要检测的条件
- (BOOL )checkBaseData{
    JLGRegisterSexTableViewCell *cell = [JLGRegisterSexTableViewCell cellWithTableView:self.tableView];
    self.mateRegisterInfo[@"gender"] = @(cell.getSexNum);
    self.parametersDic[@"gender"] = @(cell.getSexNum);
    
    //提示错误密码
    NSString *pwdString = self.parametersDic[@"pwd"];
    if (!pwdString || pwdString.length > 30) {
        [TYShowMessage showPlaint:@"密码长度6至30位"];
        return NO;
    }
    
    NSString *realName = self.parametersDic[@"realname"];
    //姓名的提示
    if(!realName){
        [TYShowMessage showPlaint:@"请输入姓名"];
        return NO;
    }
    
    if(realName.length < 2 && realName.length <= 15){
        [TYShowMessage showPlaint:@"请输入正确的姓名!"];
        return NO;
    }
    
    NSString *icnoStr = self.parametersDic[@"icno"];
    if(!icnoStr){
        [TYShowMessage showPlaint:@"请输入身份证号码"];
        return NO;
    }
    
    //验证身份证
    NSString *regex = @"(1[1-5]|2[1-3]|3[1-7]|4[1-6]|5[0-4]|6[1-5]|71|81|82|90)([0-5][0-9]|90)(\\d{2})(19|20)(\\d{2})((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))(\\d{3})([0-9]|X)";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:icnoStr];
    if (!isValid) {
        [TYShowMessage showPlaint:@"身份证号码格式错误"];
        return NO;
    }
    
    return YES;
}

#pragma mark - 选择项目类型的情况
- (void)JLGProjectTypeVc:(JLGProjectTypeViewController *)workTypeVc SelectedArray:(NSArray *)selectedArray dataDic:(NSDictionary *)dataDic{
    self.parametersDic[@"protype"] = dataDic[@"id"];
    self.mateRegisterInfo[@"protype"] = dataDic[@"name"];
    self.projectTypesSelectArray = [selectedArray mutableCopy];
    workTypeVc.delegate = nil;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 选择工种的情况
- (void)JLGPickerViewSelect:(NSArray *)finishArray{
    if (finishArray.count == 3) {//取消
        return;
    }
    
    __block NSIndexPath *indexPath;
    [finishArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSIndexPath class]]) {
            indexPath = obj;
        }
    }];
    
    self.mateRegisterInfo[[self getKeyByIndexPath:indexPath]] = [finishArray firstObject][@"name"];
    self.parametersDic[[self getKeyByIndexPath:indexPath]] = [finishArray firstObject][@"id"];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 城市选择
- (void )JLGCityPickerSelect:(NSDictionary *)cityDic byIndexPath:(NSIndexPath *)indexPath{
    self.parametersDic[[self getKeyByIndexPath:indexPath]] = cityDic[@"cityCode"];
    self.mateRegisterInfo[[self getKeyByIndexPath:indexPath]] = cityDic[@"cityName"];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - 年龄选择
- (void)JLGDatePickerSelect:(NSDictionary *)dateDic byIndexPath:(NSIndexPath *)indexPath{
    self.parametersDic[[self getKeyByIndexPath:indexPath]] = dateDic[@"age"];
    self.mateRegisterInfo[[self getKeyByIndexPath:indexPath]] = [NSString stringWithFormat:@"%@岁",dateDic[@"age"]];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)blockWithCell:(JLGRegisterInfoTableViewCell *)returnCell{
    __weak typeof(self) weakSelf = self;
    
    //beginEdit
    [returnCell beginEditWithBlock:^{
        [weakSelf.dataPicker hiddenPicker];
        [weakSelf.cityPickerView hiddenCityPicker];
    }];
    
    //endEdit
    [returnCell endEditWithBlock:^(NSIndexPath *indexPath, NSString *detailTFStr) {
        NSString *key = [self getKeyByIndexPath:indexPath];
        weakSelf.mateRegisterInfo[key] = detailTFStr;
        weakSelf.parametersDic[key] = detailTFStr;
    }];
    
    [returnCell textDidChangeBlock:^(NSIndexPath *indexPath,NSString *changeText) {
        NSString *key = [self getKeyByIndexPath:indexPath];
        weakSelf.mateRegisterInfo[key] = changeText;
        weakSelf.parametersDic[key] = changeText;
    }];
}

- (NSString *)getKeyByIndexPath:(NSIndexPath *)indexPath{
    NSString *key;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                key = @"pwd";
                break;
            case 1:
                key = @"realname";
                break;
            case 2:
                key = @"icno";
                break;
            case 4:
                key = @"age";
                break;
        }
    }else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                key = @"homearea";
                break;
            case 1:
                key = @"protype";
                break;
            case 2:
                key = @"worktype";
                break;
            case 3:
                key = @"workyear";
                break;
        }
    }else if(indexPath.section == 2 && indexPath.row == 0){
        key = @"expectaddr";
    }

    return key;
}

#pragma mark - 初始化
- (void)initData{
    //设置显示内容的数组
    [self initAutoInfoArray];
    
    //从数据库读数据
    [self sqlDataSourceInit];
    
    //初始化注册信息的dictionary
    self.mateRegisterInfo = [NSMutableDictionary dictionary];
    self.parametersDic = [NSMutableDictionary dictionary];
    self.parametersDic[@"os"] = @"I";
    self.parametersDic[@"roletype"] = @1;
    self.parametersDic[@"expectaddr"] = @"";
    self.parametersDic[@"telph"] = self.phone;
    
    //设置代理
    self.dataPicker.delegate = self;
    self.cityPickerView.delegate = self;
}

- (void)initAutoInfoArray{
    _authoInfosArray = @[
                         @[
                             @[@"登录密码:",@"设置最少6位数的密码"],
                             @[@"真实姓名:",@"请输入你的姓名"],
                             @[@"身份证号:",@"请输入你的身份证号码"],
                             @[@"",@""],
                             @[@"年龄:",@"请输入你的年龄"]
                             ],
                         @[
                             @[@"家乡:",@"请选择省、市、县"],
                             @[@"项目类型:",@"请选择项目类型"],
                             @[@"工种:",@"请选择专业方向"],
                             @[@"熟练度:",@"请选择熟练度"],
                             ],
                         @[
                             @[@"期望地址:",@"请选择工作地"]
                             ]
                         ];
}

- (void)sqlDataSourceInit{
    //初始化数据源
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //取数据库
        weakSelf.workTypesArray = [TYFMDB searchTable:@"jlg_work_type"];
        weakSelf.projectTypesArray = [TYFMDB searchTable:@"jlg_project_type"];
        weakSelf.skillTypesArray = [TYFMDB searchTable:@"jlg_work_level"];
        
        weakSelf.projectTypesSelectArray = [NSMutableArray array];
        [weakSelf.projectTypesArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            weakSelf.projectTypesSelectArray[idx] = @NO;
        }];
    });
}

- (JLGDatePickerView *)jlgDatePickerView
{
    if (!_jlgDatePickerView) {
        _jlgDatePickerView = [[JLGDatePickerView alloc] initWithFrame:TYGetUIScreenRect];
        _jlgDatePickerView.delegate = self;
        _jlgDatePickerView.backgroundColor = [UIColor clearColor];
    }
    return _jlgDatePickerView;
}

@end
